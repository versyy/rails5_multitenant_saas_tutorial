// Controls page-specific javascript functionality
//
// This assumes you have your global body layout includes the following:
// <body data-controller="<%= controller_name %>" data-action="<%= action_name %>">
//
// To add new page-specific functionality, create a controller-specific
// javascript file: ./controllers/<controller-name>
//
// Within controller specific name, you need to add controller code as
// well as your page-specific code.  Example, if you have a "SessionsController" and a "new" action,
// you would create the following:
//
// # ./controllers/sessions.js
// SITENAME.sessions = {
//   init: function() {
//     // controller-wide code
//   },
//   new: function() {
//     console.log("sessions/new page-specific javascript");
//   }
// };

SITENAME = {
  common: {
    init: function() {
      // console.log("site-wide javascript")
    }
  }
};

UTIL = {
  exec: function( controller, action ) {
    var ns = SITENAME;
    var action = ( action === undefined ) ? "init" : action;
    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
      ns[controller][action]();
    }
  },
  init: function() {
    var body = document.body;
    var controller = body.getAttribute( "data-controller" );
    var action = body.getAttribute( "data-action" );
    UTIL.exec( "common" );
    UTIL.exec( controller );
    UTIL.exec( controller, action );
  }
};

$( document ).on('turbolinks:load', UTIL.init );
