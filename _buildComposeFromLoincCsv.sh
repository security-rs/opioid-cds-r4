#!/usr/bin/env bash
#
# Build a FHIR ValueSet compose block for a urine drug screening test value set
# from a LOINC hierarchy export CSV. Output is written to stdout.
#
# Pattern:
# - Leaf codes are rows whose Code does not start with "LP".
# - Each unique LP parent of a leaf becomes a hierarchical include with filters:
#     parent = <LP code>, SYSTEM = LP7681-2 (urine), CLASSTYPE = 1 (lab)
# - Special case: LP248770-2 ("Lab terms not yet categorized") is emitted as an
#   explicit concept list of its leaves, since filtering on that parent would
#   over-pull every uncategorized urine lab term.
# - Includes appear in the order their parent rows first show up in the CSV.
#
# Usage: _buildComposeFromLoincCsv.sh <loinc-export.csv>

set -eu

if [ $# -ne 1 ]; then
  printf 'Usage: %s <loinc-export.csv>\n' "$0" >&2
  exit 2
fi

CSV_PATH="$1"
if [ ! -f "$CSV_PATH" ]; then
  printf 'Error: file not found: %s\n' "$CSV_PATH" >&2
  exit 1
fi

awk -v CONCEPT_LIST_PARENT="LP248770-2" \
    -v SYSTEM_FILTER_VALUE="LP7681-2" \
    -v CLASSTYPE_FILTER_VALUE="1" '
function parse_csv(line, fields,    i, n, in_quote, c, field, len) {
  delete fields
  n = 0; in_quote = 0; field = ""; len = length(line)
  for (i = 1; i <= len; i++) {
    c = substr(line, i, 1)
    if (in_quote) {
      if (c == "\"") {
        if (substr(line, i + 1, 1) == "\"") { field = field "\""; i++ }
        else { in_quote = 0 }
      } else { field = field c }
    } else {
      if (c == ",") { fields[++n] = field; field = "" }
      else if (c == "\"" && field == "") { in_quote = 1 }
      else { field = field c }
    }
  }
  fields[++n] = field
  return n
}

function json_escape(s,    out, i, c, len) {
  out = ""; len = length(s)
  for (i = 1; i <= len; i++) {
    c = substr(s, i, 1)
    if (c == "\"") out = out "\\\""
    else if (c == "\\") out = out "\\\\"
    else if (c == "\n") out = out "\\n"
    else if (c == "\r") out = out "\\r"
    else if (c == "\t") out = out "\\t"
    else out = out c
  }
  return out
}

NR == 1 { next }                       # skip header
{
  parse_csv($0, F)
  id = F[1]; pid = F[2]; code = F[4]; ctxt = F[6]
  order_n++; ord_id[order_n] = id
  id_code[id] = code
  if (code != "" && substr(code, 1, 2) != "LP") {
    leaf[id] = 1; leaf_pid[id] = pid; leaf_code[id] = code; leaf_text[id] = ctxt
    parent_in_use[pid] = 1
  }
  if (code == CONCEPT_LIST_PARENT) catchall_id[id] = 1
}

END {
  # Ordered unique parent codes
  np = 0
  for (k = 1; k <= order_n; k++) {
    id = ord_id[k]
    if (parent_in_use[id]) {
      c = id_code[id]
      if (!(c in seen_p)) { seen_p[c] = 1; ordered_p[++np] = c }
    }
  }
  # Catchall leaves (CSV order, deduped)
  nc = 0
  for (k = 1; k <= order_n; k++) {
    id = ord_id[k]
    if (leaf[id] && (leaf_pid[id] in catchall_id)) {
      lc = leaf_code[id]
      if (!(lc in seen_lc)) {
        seen_lc[lc] = 1
        nc++; ca_code[nc] = lc; ca_text[nc] = leaf_text[id]
      }
    }
  }

  print "{"
  print "  \"include\": ["
  for (i = 1; i <= np; i++) {
    c = ordered_p[i]
    tail = (i < np) ? "," : ""
    if (c == CONCEPT_LIST_PARENT) {
      print "    {"
      print "      \"system\": \"http://loinc.org\","
      print "      \"concept\": ["
      for (j = 1; j <= nc; j++) {
        jt = (j < nc) ? "," : ""
        print "        {"
        printf "          \"code\": \"%s\",\n", json_escape(ca_code[j])
        printf "          \"display\": \"%s\"\n", json_escape(ca_text[j])
        printf "        }%s\n", jt
      }
      print "      ]"
      printf "    }%s\n", tail
    } else {
      print "    {"
      print "      \"system\": \"http://loinc.org\","
      print "      \"filter\": ["
      print "        {"
      print "          \"property\": \"parent\","
      print "          \"op\": \"=\","
      printf "          \"value\": \"%s\"\n", json_escape(c)
      print "        },"
      print "        {"
      print "          \"property\": \"SYSTEM\","
      print "          \"op\": \"=\","
      printf "          \"value\": \"%s\"\n", SYSTEM_FILTER_VALUE
      print "        },"
      print "        {"
      print "          \"property\": \"CLASSTYPE\","
      print "          \"op\": \"=\","
      printf "          \"value\": \"%s\"\n", CLASSTYPE_FILTER_VALUE
      print "        }"
      print "      ]"
      printf "    }%s\n", tail
    }
  }
  print "  ]"
  print "}"
}
' "$CSV_PATH"
