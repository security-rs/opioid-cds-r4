const now = () => new Date();

const toISOStringNoTz = (date) => date.toISOString().replace("Z", "");

const currentDateTimeNoTz = () => toISOStringNoTz(now());

const addDays = (date, days) =>
  new Date(new Date(date).setDate(date.getDate() + days));

const subtractDays = (date, days) =>
  new Date(new Date(date).setDate(date.getDate() - days));

const getDateTimeMinusDays = (days) =>
  toISOStringNoTz(subtractDays(now(), days));

const getDateTimePlusDays = (days) => toISOStringNoTz(addDays(now(), days));

const todayDateTime = () => currentDateTimeNoTz();
const dateTimeMinus30Days = () => getDateTimeMinusDays(30);
const dateTimePlus30Days = () => getDateTimePlusDays(30);
const yesterdayDateTime = () => getDateTimeMinusDays(1);
const nowNoTz = () => currentDateTimeNoTz();

function getDateMinusYears(years) {
  const d = new Date();
  d.setFullYear(d.getFullYear() - years);
  // Format yyyy-mm-dd
  const yyyy = d.getFullYear();
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  const dd = String(d.getDate()).padStart(2, "0");
  return `${yyyy}-${mm}-${dd}`;
}

module.exports = {
  nowNoTz,
  todayDateTime,
  getDateTimeMinusDays,
  getDateTimePlusDays,
  dateTimeMinus30Days,
  dateTimePlus30Days,
  yesterdayDateTime,
  getDateMinusYears
};
