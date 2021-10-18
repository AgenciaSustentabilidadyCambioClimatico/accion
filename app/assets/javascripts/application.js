// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require jquery
// = require rails-ujs
// = require popper
// = require bootstrap-sprockets
// = require jquery_nested_form
// = require highlight.min
// = require quill.min
// = require quill.global
// = require autonumeric1
// = require data-confirm-modal
// = require geoxml3
// = require datatables
// = require ckeditor/init
// = require date
// = require date/es-ES
// = require dataTables.fixedHeader.min
// = require_tree .
// = require select2-full

dataConfirmModal.setDefaults({
  title: 'Confirme antes de continuar',
  commit: 'Confirmar',
  cancel: 'Cancelar',
  size: 'large',
  cancelClass: 'btn-outline-secondary btn-sm',
  commitClass: 'btn-outline-primary btn-sm',
  focus: 'none',
});
$(document).on('nested:fieldAdded:comentario_archivos', function() { toggleAddLink(); });
$(document).on('nested:fieldRemoved:comentario_archivos', function() { toggleAddLink(); });
/*$(document).on('nested:fieldAdded:hito_de_prensa_instrumentos', function(e) {
  e.field.find('select').val( $('#instrumento-added').val() ).attr("disabled", true); ;
  e.field.find('.instrumento-selected-hidden').val( $('#instrumento-added').val() );
});*/
//Permite agregar desde hitos de prensa nuevos instrumentos.-
$(document).on('nested:fieldAdded:hito_de_prensa_instrumentos', function(e) {
  e.field.find('label').text( $('#instrumento-added-text').val() );
  e.field.find('input').first().val( $('#instrumento-added').val() );
});

$(document).on('click', '.button-seleccione-archivo', function(){
  $("#"+$(this).data('input-file')).trigger("click");
});

$(document).on('change', ".file-seleccione-archivo", function(){
  input_cantidad_archivos = $(this)[0].files.length;
  nombre_input = "Archivo(s) no subido(s)";
  if(input_cantidad_archivos == 1){
    nombre_input = $(this)[0].files[0].name;
  }
  if(input_cantidad_archivos > 1){
    nombre_input = input_cantidad_archivos+" seleccionados";
  }
  $(this).siblings(".input-group").find(".label-seleccione-archivo").html(nombre_input);
  $(this).siblings(".input-group").find(".label-seleccione-archivo").attr('title', nombre_input);
  $(this).siblings(".input-group").find(".label-seleccione-archivo").data('original-title', nombre_input);
});

var editor;
var chosenOptions = {
  allow_single_deselect: true,
  no_results_text: 'No se encontraron resultados',
  width: '100%'
}
$(document).ready(function() {
  checkFieldValidity($('form').find('*').filter(':input:visible:first'));
  initDateTimePicker();
  enableDisabledButton();
  __tooltip({placement: 'top'}); //DZC 2019-07-09 11:58:25 se cambia 'right' por 'top'
  toggleAddLink();
  iniciarAutoNumeric();
  beauty_tree_selector();
  
  $('body').on('ajax:before','form[data-remote],a[data-remote="true"]',function(){});
  $('body').on('ajax:beforeSend','form[data-remote],a[data-remote="true"]',ajaxBeforeSendAction);
  $('body').on('ajax:send','form[data-remote],a[data-remote="true"]',function(xhr){});
  $('body').on('ajax:stopped','form[data-remote],a[data-remote="true"]',function(xhr){});
  $('body').on('ajax:success','form[data-remote],a[data-remote="true"]',function(response,status,xhr){});
  $('body').on('ajax:error','form[data-remote],a[data-remote="true"]',function(response,status,xhr){ $('.loading-data').hide()});
  $('body').on('ajax:complete','form[data-remote],a[data-remote="true"]',function(xhr,status){ $('.loading-data').hide()});
  
  $('body').on('click', '[data-toggle="modal"],a[data-remote="true"]', function(){});
  $('.dropdown-menu a.dropdown-toggle').on('click', function(e) {
    if (!$(this).next().hasClass('show')) {
      $(this).parents('.dropdown-menu').first().find('.show').removeClass("show");
    }
    var $subMenu = $(this).next(".dropdown-menu");
    $subMenu.toggleClass('show');
    $(this).parents('li.nav-item.dropdown.show').on('hidden.bs.dropdown', function(e) {
      $('.dropdown-submenu .show').removeClass("show");
    });
    return false;
  });
  $('#site-comments').modal({backdrop:'static',show: false});
  $('#site-comments').on('show.bs.modal', function (e) { $(this).find('.modal-dialog').removeClass("slideOutRight").addClass("slideInRight"); })
  $('#site-comments').on('hide.bs.modal', function (e) { $(this).find('.modal-dialog').removeClass("slideInRight").addClass("slideOutRight"); })
  $('#agregar-instrumentos,#buscar-contribuyente').modal({backdrop:'static',show:false});
  window.onscroll = function(event) { 
    scrollTop = document.documentElement.scrollTop || document.body.scrollTop
    headerRow = $('.table.permission-cargos tr.header-row')
    if (scrollTop > 0) {
      headerRow.css({opacity: 0.5})
    } else {
      headerRow.css({opacity: 1})
    }
  }
  validarRutEnTiempoReal();

  //DZC Fuerza la elección del plazo minimo al valor de 1 o más
  $('body').on('change','.numero-natural', function(e) {
    if ( $(this).val() < 1 ) {
      $(this).val(1);
    }
  }); 

  //DZC DZC 2018-10-31 10:13:03 Fuerza la elección del plazo minimo al valor de 0 o más
  $('body').on('change','.mayor-igual-a-cero', function(e) {
    if ( $(this).val() < 0 ) {
      $(this).val(0);
    }
  }); 

  //Verifica que al momento de cambiar un valor dentro de un campo que posea la clase auto-save, se ejecute el submit.
  //Salvo en los casos que posean la clase datetimepicker.-
  $('body').on('change','.auto-save', function(e) {
    var submit = $(this.form).find('input[type="submit"]');
    if ( ! $(this).hasClass('basic-datetimepicker') ) {
      submit.trigger('click');
    }
  });

  function resizeLoadingBackground() {
  loadingParent = $(".loading-data").parent().parent()[0]
    return $('.loading-data').height(loadingParent.scrollHeight);
  }

  function verticallyCenterSpinner(){
    spinner = $('.loading-data > .spinner').css({'display':'block'})
    scrollTop = document.documentElement.scrollTop || document.body.scrollTop
    spinner.css({'margin-top':window.innerHeight/2+scrollTop-spinner.height()/2});
  }

  //DZC 2018-11-19 11:03:21 muestra el icono circular al guardar datos de una vista
  function ajaxBeforeSendAction(){
    //if ( $(this).attr('id') != 'manifestacion-de-interes-form' ) {
      resizeLoadingBackground().show();
      verticallyCenterSpinner();
    //}
  }

  window.onscroll = window.onresize = function(event) {
    verticallyCenterSpinner();
    resizeLoadingBackground();
  }
  closeAlertMessage();

  $('body').on('click','group-control', function(){
    __show_hide_($(this).next('ul'),$(this));
  });

  $('body').on('click','.card-header i[class^="fa fa-chevron-"], .display_select_title', function(){
    __show_hide_($(this).closest('.card').find('.card-body'),$(this));
  });

  $('body').on('input','[type="range"]', function(){
    //console.log($(this).val());
    $(this).prev('label').find('span:last-child').html($(this).val()+' %');
  });


  $('.child-checkbox').on('click', function() {
    lists = $(this).parents('ul');
    if ( $(this).prop('checked') ) {
      lists.siblings('.parent-checkbox').prop('checked',true);
    } else {
      $.each(lists,function(lindex,list) {
        checked = 0;
        $.each($(list).children('li'),function(rindex,row) {
          checkbox = $(row).children('.child-checkbox');
          if ( checkbox.prop('checked') ) {
            checked++;
          }
        });
        if (checked == 0) {
          //checkbox.closest('ul').prev('.parent-checkbox').prop('checked',false);
        }
      });
    }
  });

  $('.parent-checkbox').on('click', function() {
    if ( ! $(this).prop('checked') ) {
      $(this).siblings('ul').find('.child-checkbox').prop('checked',false);
      //Para cambiar todos los deselleccionados a flecha derecha.-
      $(this).siblings('ul').find('.fa').removeClass('fa-chevron-down').addClass('fa-chevron-right');
    }

  });

  //Permite que al eliminar un nested-field, se quiten las clases y se active el boton
  $(document).on('nested:fieldRemoved', function(e){
    $(e.target).find(':input').removeClass('required-field not-required-if-other-like-me-is-present');
  });

  //ejecuta las aciones de spinner cuando se ejecuta una llamada ajax
  $(document).bind("ajaxSend", function(){
    loadingParent = $(".loading-data").parent().parent()[0]
    $('.loading-data').height(loadingParent.scrollHeight).show();
    spinner = $('.loading-data > .spinner').css({'display':'block'})
    scrollTop = document.documentElement.scrollTop || document.body.scrollTop
    spinner.css({'margin-top':window.innerHeight/2+scrollTop-spinner.height()/2});
  }).bind("ajaxComplete", function(){
    $('.loading-data').hide();
  });
  iniciarSoloLetras();

  $("abbr[title='required']").attr('title', 'Campo requerido');
});

function iniciarDigitoVerificador() {
  $('.dv').keypress(function(event){
    var inputValue = event.which;
    if(![48,49,50,51,52,53,54,55,56,57,75,107].includes(inputValue) || this.value.length == 1){
      event.preventDefault(); 
    }

  });
}

function iniciarSoloLetras() {
  $('.letras').keypress(function(event){
    var inputValue = event.which;
    if(!(inputValue >= 65 && inputValue <= 90) 
      && !(inputValue >= 97 && inputValue <= 122) 
      && (inputValue != 32 && inputValue != 0 && inputValue != 8)) { 
      event.preventDefault(); 
    }
  });
}

function __show_hide_(group,control) {
  if(group.hasClass('group-hide')) {
    group.show('slow').removeClass('group-hide').addClass('group-show');
  } else if(group.hasClass('group-show')) {
    group.hide('slow').removeClass('group-show').addClass('group-hide');
  }
  if(control.hasClass('fa-chevron-right')) {
    control.removeClass('fa-chevron-right').addClass('fa-chevron-down');
  } else if(control.hasClass('fa-chevron-down')) {
    control.removeClass('fa-chevron-down').addClass('fa-chevron-right');
  }

  if(control.hasClass('display_select_title') && control.next().children().first().hasClass('fa-chevron-right')) {
    control.next().children().first().removeClass('fa-chevron-right').addClass('fa-chevron-down');
  } else if(control.hasClass('display_select_title') && control.next().children().first().hasClass('fa-chevron-down')) {
    control.next().children().first().removeClass('fa-chevron-down').addClass('fa-chevron-right');
  }
}

function closeAlertMessage(seconds) {
  seconds=(seconds===undefined) ? 15000 : seconds
  cierreAlerta = setTimeout(function() {$('button[data-dismiss="alert"]').trigger("click"); }, seconds);
}

function toggleAddLink() {
  $.each($('#modal-comentario-archivos .fields[style="display: none;"]'),function(k,v){
    $(v).remove();
  });
  totalFields=$('#modal-comentario-archivos .fields').length;
  $('a.modal-comentario-archivos').toggle(totalFields <= 2);
}

function htmlErrorToTooltip(placement) {
  placement = (placement===undefined) ? 'right' : placement
  $('div.has-error').each(function(k,v) {
    campo = $(this).find("input.required, input.validado, select.required, select.validado, input[type='checkbox'], input[type='radio'], .card-body.required, .error-mantenedor, textarea, .input-group");
    error = $(this).find("span.help-block");
    if(campo.hasClass('card-body')) {
      campo = campo.parent('.card');
    }
    else if(campo.hasClass('card-wrap')) {
      campo = campo.closest('.card');
    }
    else if(campo.hasClass('multiselect-control')) {
      campo = $(this).parent().find('.btn-group');
    }
    else if(campo.is(':checkbox')) {
      campo = $(this).parent().find('div');
      error = $(this).parent().find("span.help-block");
    }
    else if(campo.is(':radio')) {
      campo = campo.closest('div')
    }
    else if(campo.hasClass('chosen-control')) {
      campo = $(this).find('.chosen-container');
    }
    mensaje = error.text();
    showTooltipError(mensaje, campo, placement);
  });
}

function showTooltipError(mensaje, campo, placement){
  campo.addClass('border-error');
  //campo.attr("title", mensaje);
  campo.attr("data-original-title", mensaje);
  campo.tooltip({
    template: '<div class="tooltip error" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>',
    trigger: 'hover',//manual
    placement: placement,
    html: true,
  })//.tooltip('show')
}

function hideTooltipError(campo){
  campo.removeClass('border-error');
  campo.attr("title", '');
  campo.attr("data-original-title", '');
  campo.tooltip('hide');
}


var currentDateSelected = null;
var basicOptions = {
  i18n:{
    es:{
     months:[ "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre",],
     dayOfWeek:[ "Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb" ]
    }
  },
  dayOfWeekStart: 1,
  timepicker:false,
  format:'d-m-Y',
  formatDate:'d-m-Y',
  onSelectDate:function(ct,$i){
    if ( $i.val() != currentDateSelected ) {
      currentDateSelected = $i.val();
      if ( $i.hasClass('auto-save') && $($i[0].form).attr('data-remote') == 'true'  ) {
        $($i[0].form).find('input[type="submit"]').trigger('click');
      }
    }
  }
}
var anotherDateFormatOption = {
  i18n:{
    es:{
     months:[ "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre",],
     dayOfWeek:[ "Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb" ]
    }
  },
  dayOfWeekStart: 1,
  timepicker:false,
  format:'d/m/Y',
  onSelectDate:function(ct,$i){
    if ( $i.val() != currentDateSelected ) {
      currentDateSelected = $i.val();
      if ( $i.hasClass('auto-save') && $($i[0].form).attr('data-remote') == 'true'  ) {
        $($i[0].form).find('input[type="submit"]').trigger('click');
      }
    }
  }
}

function initDateTimePicker() {
  jQuery.datetimepicker.setLocale('es');

  $('.basic-datetimepicker').datetimepicker(basicOptions);
  $('.alternative-datetimepicker').datetimepicker(anotherDateFormatOption);
  $('.basic-datetimepicker-max-year-this').datetimepicker($.extend({},basicOptions,{yearEnd: (new Date).getFullYear()}));
  $('.basic-datetimepicker-max-today').datetimepicker($.extend({},basicOptions,{maxDate: 0}));
  $('.basic-datetimepicker-min-today').datetimepicker($.extend({},basicOptions,{minDate: 0}));
  $('.basic-datetimepicker-max-today').datetimepicker($.extend({},basicOptions,{maxDate: 0}));
}

//DZC 2018-11-05 10:32:55 habilita el botón de envío al ejecutar el chequeo de viabilidad
function enableDisabledButton() {
  $('body').on('keyup change click','.required-field, .not-required-if-other-like-me-is-present, .not-required-if-other-like-me-is-present-2, .im-not-required-check-the-others',function(e){
    checkFieldValidity(e);
  });
}

function __tooltip(options) {
  $.extend(options, { template: '<div class="tooltip info" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'/*, trigger: 'manual'*/})
  $('.tooltip-block').tooltip(options)//.tooltip('show');
}

function checkRutValidity(input) {
  rut = $.trim(input.val());
  return Fn.validaRut(rut);
}

function validarRutEnTiempoReal(mensaje) {
  if (mensaje===undefined) { mensaje="El R.U.T ingresado es INCORRECTO." }
  $('body').on('change focusout','.identificacion',function() {
    divAcceso=$(this).parent('div');
    inputAcceso=divAcceso.find('.identificacion');
    if (checkRutValidity(inputAcceso)) { $('.check-validity').removeAttr('disabled');
    } else { $('.check-validity').attr('disabled','disabled'); }
    if ( $(this).val() == "" || checkRutValidity(inputAcceso) ) {
      divAcceso.removeClass('error field_with_errors');
      inputAcceso.removeClass('border-error');inputAcceso.tooltip('hide');
      inputAcceso.removeAttr('title');inputAcceso.siblings('span.error').hide().tooltip('destroy');
    } else {
      divAcceso.addClass('error');
      inputAcceso.addClass('border-error'); inputAcceso.attr("title", mensaje);
      inputAcceso.tooltip({
        template: '<div class="tooltip error" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
        trigger: 'manual'
      }).tooltip('show');
    }
  });
  $('body').on('keyup blur','.identificacion',function() {
    $(this).val( $.formatRut($(this).val()) );
  });
}

function checkFieldValidity(e) {
  enable = true;
  if ($(e.target).length > 0) {
    target_form = $(e.target.form)
  } else {
   target_form = $(e).parents('form')
  }
  btn = target_form.find('.btn-disabled');
  rbtn = $('.related-disabled-button')
  required_fields = target_form.find('.required-field')
  if (target_form.find('.not-required-if-other-like-me-is-present').length > 0 ) {
    other_like_those_is_present = false
    $.each(target_form.find('.not-required-if-other-like-me-is-present'),function() {
       c = getAllTheChecks($(this));
      if ( ! ( c.is_not_checked || c.is_a_empty_value || c.is_an_invalid_id ) ) {
        other_like_those_is_present = true;
        return true;
      }
    });
  } else {
    other_like_those_is_present = true
  }
  if (target_form.find('.not-required-if-other-like-me-is-present-2').length > 0 ) {
    other_like_those_is_present_2 = false
    $.each(target_form.find('.not-required-if-other-like-me-is-present-2'),function() {
       c = getAllTheChecks($(this));
      if ( ! ( c.is_not_checked || c.is_a_empty_value || c.is_an_invalid_id ) ) {
        other_like_those_is_present_2 = true;
        return true;
      }
    });
  } else {
    other_like_those_is_present_2 = true
  }
  $.each(required_fields,function() {
    if ( $(this).closest('.nested-row-removed').length == 0 ) {
      c = getAllTheChecks($(this))
      if ( c.is_not_checked || c.is_a_empty_value || c.is_an_invalid_id || c.is_a_empty_file ) { 
        enable = false;
        return false; 
      }
    }
  });
  // console.log(enable, other_like_those_is_present, other_like_those_is_present_2)
  if (enable && other_like_those_is_present && other_like_those_is_present_2) { btn.removeAttr('disabled'); rbtn.removeAttr('disabled'); } else { btn.attr('disabled','disabled'); rbtn.attr('disabled','disabled'); }
}

function getAllTheChecks(e) {
  c={}
  c['is_not_checked'] = ( $(e).is(':checkbox') && ! $(e).prop('checked') );
  c['is_a_empty_value'] = ( ! $(e).val() );
  c['is_an_invalid_id'] = ($(e).hasClass('identificacion') && checkRutValidity($(e))==false);
  c['is_a_empty_file'] = ( $(e).is(':file') && $(e).get(0).files.length == 0 );
  return c
}

function fillSelector(namedAs,withThisDataArray,emptyit) {
  if ( emptyit === undefined || emptyit === true) {
    $(namedAs).empty();
  }
  $.each(withThisDataArray,function(k,v) {
    $(namedAs).append("<option selected='selected' value='"+v[1]+"'>"+v[0]+"</option>");
  });
}

function randomString(n1,n2,n3) {
  n1 = ((n1===undefined) ? 36 : parseInt(n1))
  n2 = ((n2===undefined) ? 2 : parseInt(n2))
  n3 = ((n3===undefined) ? 15 : parseInt(n3))
  return Math.random().toString(n1).substring(n2, n3) + Math.random().toString(n1).substring(n2, n3);
}

function number_to_currency(number) {
  return "$"+number.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.");
}
function moneyToNumber(mount){
  var aux = ""
  aux = mount.replace("$","").replace(/\./g,"")
  return aux;
}

var Fn = {
  // Valida el rut con su cadena completa "XXXXXXXX-X"
  validaRut : function (rutCompleto) {
    rutCompleto=rutCompleto.replace(/[^0-9\-kK]+/g,'').toUpperCase();
    if (!/^[0-9]+[-|‐]{1}[0-9Kk]{1}$/.test( rutCompleto ))
      return false;
    var tmp   = rutCompleto.split('-');
    var digv  = tmp[1]; 
    var rut   = tmp[0];
    //if ( digv == 'K' ) digv = 'k' ;
    return (Fn.dv(rut) == digv );
  },
  dv : function(T){
    var M=0,S=1;
    for(;T;T=Math.floor(T/10))
      S=(S+T%10*(9-M++%6))%11;
    return S?S-1:'K';
  }
}

function __enable_fieds_if_checkbox_is_true(checkbox,true_callback,false_callback)
{
  if ( $(checkbox).length > 0 ) {
    id  = $(checkbox).attr("id");
    if(id != undefined){
      if(id.indexOf("true")>0) {
        if ( typeof true_callback === "function" ) {
          true_callback(checkbox);
        }
      } else if (id.indexOf("false")>0) {
        if ( typeof false_callback === "function" ) {
          false_callback(checkbox);
        }
      }
    }
  }
}

function iniciarAutoNumeric() {
  $('.moneda').autoNumeric('init', autoNumericMonedaOptions() );
  //$('.dia-anual').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, vMax: 365, mDec: 1});
  //$('.dia-mensual').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, vMax: 31, mDec: 1});
  //$('.dia-semanal').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, vMax: 7, mDec: 1});
  //$('.dias-trabajados').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, vMax: 30, mDec: 1});

  //$('.hora-extra-mensual').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, vMax: 100, mDec: 1});
  //$('.hora-extra-semanal').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, vMax: 25, mDec: 1});
  //$('.dia-libre').autoNumeric('init', {aSep: '.', aDec: ',', aPad: false, vMin: -30.0, vMax: 30, mDec: 2});
  //$('.numero-entero').autoNumeric('init', {aSep: '', vMin: 0, vMax: 10, mDec: 0});
  //$('.numero-cargas').autoNumeric('init', {aSep: '', vMin: 0, vMax: 50, mDec: 0});
  //$('.numero-boleta').autoNumeric('init', {aSep: '', vMin: 0, vMax: 99999, mDec: 0});
  $('.numero').autoNumeric('init', {aSep: '', vMin: 0, mDec: 0});
  $('.numero-1-100').autoNumeric('init', {aSep: '', vMin: 0, vMax: 100, mDec: 0, wEmpty: 'empty'});
  $('.numero-dias-duracion').autoNumeric('init', {aSep: '', vMin: 0, vMax: 70, mDec: 0, wEmpty: 'empty'});
  $('.numero-1-7').autoNumeric('init', {aSep: '', vMin: 0, vMax: 7, mDec: 0, wEmpty: 'empty'});
  $('.numero-en-miles').autoNumeric('init', {aSep: '.', aDec: ',', vMin: 0, mDec: 0});
  $('.uf').autoNumeric('init', autoNumericUfOptions() );
  $('.porcentaje').autoNumeric('init', autoNumericPorcentajeOptions() );
  $('.decimal').autoNumeric('init', {aSep: '.', aDec: ',',aPad: false, vMin: 0.0});
}

function autoNumericPorcentajeOptions() {
  return {aSep: ',', aDec: '.', aPad: false, vMin: 0.0, vMax: 100, mDec: 2, aSign: '%', pSign: 's'};
}

function autoNumericMonedaOptions() {
  return {aSep: '.', aDec: ',', aPad: false, vMin: 0.0, aSign: '$'};
}

function autoNumericUfOptions() {
  return {aSep: '.', aDec: ',',aPad: false, vMin: 0.0, vMax: 99, mDec: 4};
}

// Busca las traducciones faltantes y devuelve la traducción para agregarlo al yaml
function dameTraduccionesFaltantes(){
  var result = {}
  $('span.translation_missing, [placeholder*="translation_missing"]').each(function(){
    campo = $(this).text() || $(this).attr('placeholder');
    llave = campo.replace(/\s+/g, '_').toLowerCase();
    valor = campo.replace(/(?:^|[A-Z]|\b)/g, function(letter, index){ return index == 0 ? letter.toUpperCase() : letter.toLowerCase()});
    result[llave] = valor;
  });
  return result;
}


function calcular_rendicion(elemento){

  var fecha_sel = $(elemento).val().split('-');
  var fecha_sel_format = new Date(fecha_sel[2], fecha_sel[1] -1, fecha_sel[0]);
  var tr = $(elemento).closest('tr');

  var index = $('#row-rendiciones tbody').children('tr:visible').index(tr);

  if(index > 0){
    var fecha_anterior = $('.basic-datetimepicker-max-year-this:visible').eq(index-1).val().split('-');
    var fecha_anterior_format = new Date(fecha_anterior[2], fecha_anterior[1] -1, fecha_anterior[0]);
    if(fecha_sel_format <= fecha_anterior_format){
      showTooltipError('Indique fecha posterior a rendición anterior', $(elemento), 'top');
      $(elemento).val("");
      return;
    }
  }

  var rrhh_propio = 0;
  var rrhh_externo_liquido = 0;
  var rrhh_externo_fpl = 0;
  var gastos_op_valor = 0;
  var gastos_op_liquido = 0;
  var gastos_op_fpl = 0;
  var gastos_adm_valor = 0;
  var gastos_adm_liquido = 0;
  var gastos_adm_fpl = 0;
  var suma_valorado = 0;
  var suma_liquido = 0;
  var suma_fpl = 0;

  $.each(actividades, function(i, montos){
    var fecha_fin = new Date(montos.fecha_finalizacion);
    if(fecha_fin <= fecha_sel_format && 
    (fecha_anterior_format == null || fecha_fin > fecha_anterior_format)){
      rrhh_propio += montos.rrhh_propios;
      rrhh_externo_liquido += montos.rrhh_externos_liquido;
      rrhh_externo_fpl += montos.rrhh_externos_fpl;
      gastos_op_valor += montos.gastos_operaciones_valor;
      gastos_op_liquido += montos.gastos_operaciones_liquido;
      gastos_op_fpl += montos.gastos_operaciones_fpl;
      gastos_adm_valor += montos.gastos_adm_valor;
      gastos_adm_liquido += montos.gastos_adm_liquido;
      gastos_adm_fpl += montos.gastos_adm_fpl;
    }
  });

  suma_valorado = rrhh_propio + gastos_op_valor + gastos_adm_valor;
  suma_liquido = rrhh_externo_liquido + gastos_op_liquido + gastos_adm_liquido;
  suma_fpl = rrhh_externo_fpl + gastos_op_fpl + gastos_adm_fpl;

  tr.children('#rrhh_propio').html(number_to_currency(rrhh_propio));
  tr.children('#rrhh_externo_liquido').html(number_to_currency(rrhh_externo_liquido));
  tr.children('#rrhh_externo_fpl').html(number_to_currency(rrhh_externo_fpl));
  tr.children('#gastos_op_valor').html(number_to_currency(gastos_op_valor));
  tr.children('#gastos_op_liquido').html(number_to_currency(gastos_op_liquido));
  tr.children('#gastos_op_fpl').html(number_to_currency(gastos_op_fpl));
  tr.children('#gastos_adm_valor').html(number_to_currency(gastos_adm_valor));
  tr.children('#gastos_adm_liquido').html(number_to_currency(gastos_adm_liquido));
  tr.children('#gastos_adm_fpl').html(number_to_currency(gastos_adm_fpl));
  tr.children('#suma_valorado').html(number_to_currency(suma_valorado));
  tr.children('#suma_liquido').html(number_to_currency(suma_liquido));
  tr.children('#suma_fpl').html(number_to_currency(suma_fpl));
  tr.find('input.suma-fpl-hidden').val(suma_fpl);
  total_sumado = suma_valorado + suma_liquido + suma_fpl;
  tr.children('#total').html(number_to_currency(total_sumado));

  if(total_sumado == 0){
    showTooltipError('Indique fecha que contenga actividades', $(elemento), 'top');
    $(elemento).val("");
    return;
  }

  hideTooltipError($(elemento));
}

function calcular_rendicion_mod(elemento){
    var fechaSel = $(elemento).val().split('-');
    var fechaSelFormat = new Date(fechaSel[2], fechaSel[1] -1, fechaSel[0]);
    var tr = $(elemento).closest('tr');

    var index = $('#row-rendiciones tbody').children('tr').index(tr);
    fechaAnteriorFormat = new Date("1900","01","01")
    if(index > 0){
      var fechaAnterior = $('.basic-datetimepicker-max-year-this:visible')
      if ( fechaAnterior.lenght > 0 ) {
        fechaAnterior.eq(index-1).val().split('-');
        var fechaAnteriorFormat = new Date(fechaAnterior[2], fechaAnterior[1] -1, fechaAnterior[0]);
        if(fechaSelFormat <= fechaAnteriorFormat){
          showTooltipError('Indique fecha posterior a rendición anterior', $(elemento), 'top');
          $(elemento).val("");
          return;
        }
      }
    }
    totalEntreFechas = 0
    $('.fecha-finalizacion span').each(function(){
      // sumar montos entre ultima fecha de rendicion y actual
      var fechaRevisar = $(this).text().split('-');
      var fechaRevisarFormat = new Date(fechaRevisar[2].replace('/[^\d]+/',""), fechaRevisar[1].replace('/[^\d]+/',"") -1, fechaRevisar[0].replace('/[^\d]+/',""));
      if(fechaRevisarFormat > fechaAnteriorFormat && fechaRevisarFormat <= fechaSelFormat){
        monto = parseInt($(this).parent().find('.monto-total-items').val()) || 0
        totalEntreFechas += monto
      }
    })
    if(totalEntreFechas == 0){
      showTooltipError('Indique fecha que contenga actividades', $(elemento), 'top');
      $(elemento).val("");
      return;
    }
    hideTooltipError($(elemento));
  }

function required_dinamico(clase, requerido){
  var asterisco = '<abbr title="required">*</abbr>'
  var div_clase = $(clase);
  var label = div_clase.find("label").first();
  var interactor = div_clase.find("input,select,textarea");
  interactor.attr("required", false);
  interactor.attr("aria-required", false);
  interactor.removeClass("required");
  interactor.removeClass("optional");
  div_clase.removeClass("required");
  div_clase.removeClass("optional");
  label.removeClass("required");
  label.removeClass("optional");
  label.html(label.html().replace(asterisco,""));
  if(requerido){
    label.html(asterisco+label.html());
    label.addClass("required");
    interactor.attr("required", true);
    interactor.attr("aria-required", true);
    interactor.addClass("required");
    div_clase.addClass("required");
  }

}


function isAValidURL(str) {
  var pattern = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
  if (pattern.test(str)) {
    // alert("Url is valid");
    return true;
  } else {
    // alert("Url is not valid!");
    return false;
  }
}

//Permite verificar un cambio dentro de un modal de busqueda y al seleccionar remover el disabled del boton.
function verificarModal(){
  $('body').on('change','.contribuyente-radio',function() {
    // DZC 2019-06-17 12:48:00 se modifica para que solo se pueda seleccionar un contribuyente
    seleccionado = $(this);
    $('table.contribuyentes').DataTable().$('.contribuyente-radio').each(function(){
      $(this).prop("checked", false);
    });
    seleccionado.prop("checked", true);
    $('.seleccionar-contribuyente-button').removeAttr('disabled'); 
    $('.seleccionar-y-actualizar-contribuyente-button').removeAttr('disabled'); 
  });  
}

function beauty_tree_selector(){
  $('.tree-parent-icon').click(function(){
    if($(this).hasClass('fa-chevron-right')){
      $(this).parent().children('div').removeClass('d-none');
      $(this).removeClass('fa-chevron-right');
      $(this).addClass('fa-chevron-down');
    }else{
      $(this).parent().children('div').addClass('d-none');
      $(this).removeClass('fa-chevron-down');
      $(this).addClass('fa-chevron-right');
    }
  });

  $('.tree-parent-icon').parent("li").children("label").click(function(){
    var icono = $(this).parent("li").children("i");
    if(icono.hasClass('fa-chevron-right')){
      icono.parent().children('div').removeClass('d-none');
      icono.removeClass('fa-chevron-right');
      icono.addClass('fa-chevron-down');
    }else{
      icono.parent().children('div').addClass('d-none');
      icono.removeClass('fa-chevron-down');
      icono.addClass('fa-chevron-right');
    }
  });

  $('.tree-parent').change(function(e){
    var input_padre = $(this).closest("div").parent().children(".tree-parent");
    var hijos = $(this).parent().children("div").find(".tree-parent");
    if(this.checked){
      hijos.prop("checked", true);
    }else{
      hijos.prop("checked", false);
    }
    hijos.prop("indeterminate", false);
    if(input_padre.length != 0){
      beauty_tree_check_children(input_padre);
    }
  });

  $('.tree-parent[data-indeterminate="true"]').prop("indeterminate", true);

  $('.tree-parent').change(function(){
    card_tree = $(this).closest('.card');
    if(card_tree.hasClass('card-preview-seleccionados')){
      set_seleccionados_tree(card_tree);
    }
  });

  $('.card-preview-seleccionados').each(function(){
    set_seleccionados_tree($(this));
  });
}

function beauty_tree_check_children(parent){
  var input_padre = parent.closest("div").parent().children(".tree-parent");
  var hijos = parent.parent().children("div").find(".tree-parent");
  var hijos_checked = hijos.filter(":checked");
  if(hijos_checked.length == 0){
    parent.prop("checked", false);
    parent.prop("indeterminate", false);
  }else if(hijos.length == hijos_checked.length){
    parent.prop("checked", true);
    parent.prop("indeterminate", false);
  }else{
    parent.prop("checked", false);
    parent.prop("indeterminate", true);
  }
  if(input_padre.length != 0){
    beauty_tree_check_children(input_padre);
  }
}

function set_seleccionados_tree(card){
  lista_html = card.find('.seleccionados_tree');
  solo_lectura = false;
  if(lista_html.length == 0){
    lista_html = card.find('.seleccionados_tree_solo_lectura');
    solo_lectura = true;
  }
  lista_html.html("");
  lista_elementos = card.children(".card-body").children("div").children("div").children("div").children("div").children("ul").children("li").children(".tree-parent");
  _set_seleccionados_tree(lista_html,lista_elementos, solo_lectura);
}

function _set_seleccionados_tree(lista_html,lista_elementos, solo_lectura){
  lista_elementos.each(function(index){
    if($(this).prop("checked")){
      var nombre = $(this).parent().children("label").html();
      var data_type = $(this).parent().children("label").children(".type");
      if(data_type.length > 0){
        nombre += " ("+data_type.html()+")";
      }
      clase_li = "list-group-item py-1 ";
      if(solo_lectura){
        clase_li = "";
      }
      lista_html.append("<li class='"+clase_li+" letter-size' id='"+this.value+"'>"+nombre+"</li>");
    }else if($(this).prop("indeterminate")){
      sub_lista = $(this).parent().children("div").children("ul").children("li").children(".tree-parent");
      _set_seleccionados_tree(lista_html, sub_lista, solo_lectura);
    }
  });
}