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
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require bootstrap
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require jquery-fileupload/basic
//= require summernote/summernote-bs4.min
//= require local-time
//= require best_in_place
//= require best_in_place.jquery-ui
//= require_tree .

var dataTable;
var lastFilter;

var app={
  initDataTable: function(){
    if ($.fn.dataTable.isDataTable('.datatable')){
      $('.datatable').DataTable().destroy();
    }

   dataTable = $('.datatable').DataTable({
      stateSave: true,
      sPaginationType: "full_numbers",
      bProcessing: true,
      "language": {
        "processing": "loading..."
      },
      bServerSide: true,
      sAjaxSource: $('.datatable').data('source'),
      order: [[ 2, "asc" ]],
      searchHighlight: true,
      bDeferRender: true,
      columnDefs: [
        { width: "10px", targets: [0, 4, -1, -2] },
        { width: "50px", targets: [2] },
        { width: "80px", targets: [3, 5] },
        { orderable: false, targets: [0, 1, 4, -1, -2] }
      ]
    }).on( "draw.dt", function(){
      $('a.marketing_request_state').each(function(idx, a){
        app.resetCustomFilter(a);
      });
    });

    $('.datatable').css("min-height", "300px");

    $('.dataTables_filter input')
      .unbind().bind('keyup', function(e){
        var q = $.trim( $(this).val());
        if (q.length < 3) q = '';
        if (q===lastFilter) return;
        dataTable.search(q).draw();
        lastFilter = q;
    });

    app.initCustomFilters();
  },

  initCustomFilters: function(){
    $('a.marketing_request_state').on('click', function(e){
      var a = $(e.target);

      if (!$(a).attr('data-label')){
        a = $(a).closest('a');
      }

      if ( a.hasClass("selected") ){
        a.removeClass("selected");
      } else{
        a.addClass("selected");
      }

      var selection = $.map( $('a.marketing_request_state.selected'), function(a){
        return $(a).data('state');
      });

      if (selection.length==0) {
        selection.push('none')
      }

      dataTable.columns(4).search(selection).draw();
      event.preventDefault();
    });
  },

  resetCustomFilter: function(a){
    var label = $(a).attr('data-label');
    var state = $(a).attr('data-state');
    var selected = $(a).hasClass('selected');

    if ( dataTable && dataTable.state() ) {
      var dtStateFilter = dataTable.state().columns[4].search.search;
      if ( dtStateFilter.length !== 0 ) {
        selected = dtStateFilter.indexOf(state) !== -1;
      }
    }

    if (selected){
      $(a).html('<span class="glyphicon glyphicon-ok"></span> '+label);
      $(a).addClass("selected");

    } else{
      $(a).html('<span class="glyphicon">&nbsp;</span> '+label);
      $(a).removeClass("selected");
    }   
  }
};

$(document).on('turbolinks:load', function () {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      height: 200,
      toolbar: []
    });
  });

  $(".priority-filter li").on("click", function(e){
    var li = $(e.target);
    var id = $(li).closest("ul").data("id");
    var priority = $(li).text();

    $("#priority").html( priority );

    $.ajax({ url: "/marketing_requests/"+id,
             type: "PUT",
             data: { marketing_request: { priority: priority }}});
  });

  app.initDataTable();

  $(".best_in_place").best_in_place();

  $(".nav-tabs a[data-nav]").on('click', function(e){
    var target = $(e.target);
    if (target.closest('li').hasClass('active')) {
      return false;
    }
    $(".nav-tabs li").removeClass('active');
    target.closest('li').addClass('active');
    $('.nav-content').hide();
    $(target.data('nav')).show();
    return false;
  });
});

$(document).on('turbolinks:before-cache', function() {
  if ($.fn.dataTable.isDataTable('.datatable')){
    $('.datatable').DataTable().destroy();
  }
});
