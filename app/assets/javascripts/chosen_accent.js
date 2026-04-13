(function () {
  // Función de normalización mejorada
  function normalizeText(text) {
    if (!text) return "";
    // Normalizamos, quitamos tildes y pasamos a minúsculas, 
    // pero mantenemos los espacios intactos.
    return text.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
  }

  function patchChosen() {
    if (!$.fn.chosen) return;
    if ($.fn.chosen.__accentPatchApplied) return;
    $.fn.chosen.__accentPatchApplied = true;

    const originalChosen = $.fn.chosen;

    $.fn.chosen = function (options) {
      const result = originalChosen.apply(this, arguments);

      this.each(function () {
        const chosen = $(this).data("chosen");
        if (!chosen || chosen.__accentPatchApplied) return;
        chosen.__accentPatchApplied = true;

        // Sobrescribimos el método de búsqueda interna
        const originalWinnow = chosen.winnow_results;

        chosen.winnow_results = function () {
          // 1. Obtenemos el texto de búsqueda original (con espacios y tildes)
          const queryOriginal = this.get_search_text();
          // 2. Creamos la versión normalizada para comparar
          const queryNormalized = normalizeText(queryOriginal);

          // 3. Normalizamos temporalmente los datos de los resultados
          this.results_data.forEach(result => {
            if (result.text && !result._normalized_text) {
              result._original_text = result.text;
              result._normalized_text = normalizeText(result.text);
            }
            // Cambiamos el texto al normalizado para que winnow_results haga el match
            if (result._normalized_text) {
              result.text = result._normalized_text;
            }
          });

          // --- LA CLAVE ---
          // En lugar de hacer this.search_field.val(), pasamos el texto normalizado
          // a una variable temporal que Chosen usa para filtrar si fuera posible, 
          // pero como winnow_results usa get_search_text, aplicamos el parche ahí:
          const self = this;
          const oldGetSearchText = this.get_search_text;
          this.get_search_text = function() { return queryNormalized; };

          // Ejecutar búsqueda original con textos normalizados
          const response = originalWinnow.apply(this, arguments);

          // 4. Restauramos TODO a su estado original inmediatamente
          this.get_search_text = oldGetSearchText;
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

  // ... (initChosen, turbolinks:load y document.ready se mantienen igual)
  function initChosen() {
    $('.chosen-control').each(function() {
        if (!$(this).data('chosen')) {
            $(this).chosen(window.chosenOptions || {});
        }
    });
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