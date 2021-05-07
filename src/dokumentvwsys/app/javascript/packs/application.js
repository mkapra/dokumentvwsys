// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application
// logic in a relevant structure within app/javascript and only use these pack
// files to reference that code so it'll be compiled.

global.toastr = require("toastr");

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import '@popperjs/core';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import bootstrap from "bootstrap"

require("bootstrap-datepicker");
require("bootstrap-datepicker/dist/locales/bootstrap-datepicker.de.min.js");

import bsCustomFileInput from "bs-custom-file-input";

$(document).ready(function() { bsCustomFileInput.init(); });

$.fn.datepicker.defaults.language = "de";
