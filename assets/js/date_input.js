import AirDatepicker from "air-datepicker";

let customLocale = {
  days: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"],
  daysShort: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"],
  daysMin: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"],
  months: [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro",
  ],
  monthsShort: [
    "Jan",
    "Fev",
    "Mar",
    "Abr",
    "Mai",
    "Jun",
    "Jul",
    "Ago",
    "Set",
    "Out",
    "Nov",
    "Dez",
  ],
  today: "Hoje",
  clear: "Limpar",
  dateFormat: "dd/MM/yyyy",
  timeFormat: "HH:mm",
  firstDay: 0,
};

new AirDatepicker("#air-datepicker", {
  locale: customLocale,
  navTitles: {
    days: "<i>MMMM</i>",
  },
  autoClose: true,
  position({ $datepicker, $target, $pointer }) {
    let coords = $target.getBoundingClientRect(),
      dpWidth = $datepicker.clientWidth;

    let top = coords.y + coords.height;
    let left = coords.x + (coords.width - 2) / 2 - dpWidth / 2;

    $datepicker.style.left = `${left}px`;
    $datepicker.style.top = `${top}px`;
    $pointer.style.display = "none";
  },
});
