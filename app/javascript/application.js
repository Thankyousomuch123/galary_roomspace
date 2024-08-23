// app/javascript/packs/application.js

import Rails from "@rails/ujs";
import { Turbo } from "@hotwired/turbo-rails";
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import $ from 'jquery'; // Include jQuery if necessary

// Initialize Rails UJS
Rails.start();

// Initialize Turbo
Turbo.start();

// Ensure jQuery is available globally if needed
window.$ = $;

// Add any custom JavaScript below
