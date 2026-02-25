(function () {

  function normalizeText(text) {
    return text
      ? text.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase()
      : "";
  }

  function patchChosen() {
    if (!$.fn.chosen) return;

    // Evita parchear más de una vez
    if ($.fn.chosen.__accentPatchApplied) return;
    $.fn.chosen.__accentPatchApplied = true;

    const originalChosen = $.fn.chosen;

    $.fn.chosen = function (options) {

      const result = originalChosen.apply(this, arguments);

      this.each(function () {

        const chosen = $(this).data("chosen");
        if (!chosen) return;

        if (chosen.__accentPatchApplied) return;
        chosen.__accentPatchApplied = true;

        const originalWinnow = chosen.winnow_results;

        chosen.winnow_results = function () {

          const searchText = normalizeText(this.get_search_text());

          this.results_data.forEach(result => {
            if (result.text) {
              result._original_text = result.text;
              result.text = normalizeText(result.text);
            }
          });

          this.search_field.val(searchText);

          const response = originalWinnow.apply(this, arguments);

          this.results_data.forEach(result => {
            if (result._original_text) {
              result.text = result._original_text;
            }
          });

          return response;
        };

      });

      return result;
    };
  }

  function initChosen() {
    $('.chosen-control').chosen(window.chosenOptions || {});
  }

  document.addEventListener("turbolinks:load", function () {
    patchChosen();
    initChosen();
  });

  $(document).ready(function () {
    patchChosen();
    initChosen();
  });

})();