#requires -Version 5.1
<#
.SYNOPSIS
Build a FHIR ValueSet compose block for a urine drug screening test value set
from a LOINC hierarchy export CSV. Output is written to stdout.

.DESCRIPTION
Pattern:
- Leaf codes are rows whose Code does not start with "LP".
- Each unique LP parent of a leaf becomes a hierarchical include with filters:
    parent = <LP code>, SYSTEM = LP7681-2 (urine), CLASSTYPE = 1 (lab)
- Special case: LP248770-2 ("Lab terms not yet categorized") is emitted as an
  explicit concept list of its leaves, since filtering on that parent would
  over-pull every uncategorized urine lab term.
- Includes appear in the order their parent rows first show up in the CSV.

.EXAMPLE
.\_buildComposeFromLoincCsv.ps1 path\to\Loinc_2.82_Export.csv
#>
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$CsvPath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $CsvPath -PathType Leaf)) {
    Write-Error "File not found: $CsvPath"
    exit 1
}

$ConceptListParent    = 'LP248770-2'
$SystemFilterValue    = 'LP7681-2'
$ClasstypeFilterValue = '1'

$rows = Import-Csv -LiteralPath $CsvPath

$parentIdsInUse = @{}
foreach ($r in $rows) {
    if ($r.Code -and -not $r.Code.StartsWith('LP')) {
        $parentIdsInUse[$r.ParentId] = $true
    }
}

$orderedParents = New-Object System.Collections.Generic.List[string]
$seen = @{}
foreach ($r in $rows) {
    if ($parentIdsInUse.ContainsKey($r.Id) -and -not $seen.ContainsKey($r.Code)) {
        $seen[$r.Code] = $true
        $orderedParents.Add($r.Code)
    }
}

$catchallIds = @{}
foreach ($r in $rows) {
    if ($r.Code -eq $ConceptListParent) { $catchallIds[$r.Id] = $true }
}

$catchallLeaves = New-Object System.Collections.Generic.List[object]
$seenLeaf = @{}
foreach ($r in $rows) {
    if ($r.Code -and -not $r.Code.StartsWith('LP') -and `
        $catchallIds.ContainsKey($r.ParentId) -and `
        -not $seenLeaf.ContainsKey($r.Code)) {
        $seenLeaf[$r.Code] = $true
        $catchallLeaves.Add([ordered]@{ code = $r.Code; display = $r.CodeText })
    }
}

$includes = New-Object System.Collections.Generic.List[object]
foreach ($code in $orderedParents) {
    if ($code -eq $ConceptListParent) {
        $includes.Add([ordered]@{
            system  = 'http://loinc.org'
            concept = $catchallLeaves.ToArray()
        })
    } else {
        $includes.Add([ordered]@{
            system = 'http://loinc.org'
            filter = @(
                [ordered]@{ property = 'parent';    op = '='; value = $code }
                [ordered]@{ property = 'SYSTEM';    op = '='; value = $SystemFilterValue }
                [ordered]@{ property = 'CLASSTYPE'; op = '='; value = $ClasstypeFilterValue }
            )
        })
    }
}

$compose = [ordered]@{ include = $includes.ToArray() }
$compose | ConvertTo-Json -Depth 10
