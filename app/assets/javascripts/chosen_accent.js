(function () {

  function normalizeText(text) {
    return text
      ? text
          .normalize("NFD")
          .replace(/[\u0300-\u036f]/g, "") // Elimina tildes
          .replace(/\s+/g, " ")            // Mantiene un solo espacio entre palabras
          .trim()
          .toLowerCase()
      : "";
  }

  function patchChosen() {
    if (!$.fn.chosen) return;

    // Evita aplicar el parche más de una vez
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
          // Mantiene el texto original del usuario
          const originalSearchText = this.get_search_text();
          const normalizedSearchText = normalizeText(originalSearchText);

          // Normaliza los textos para la comparación
          this.results_data.forEach(result => {
            if (result.text) {
              result._normalized_text = normalizeText(result.text);
            }
          });

          // Sobrescribe temporalmente el método de búsqueda
          const originalGetSearchText = this.get_search_text;
          this.get_search_text = function () {
            return normalizedSearchText;
          };

          const response = originalWinnow.apply(this, arguments);

          // Restaura el método original
          this.get_search_text = originalGetSearchText;

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