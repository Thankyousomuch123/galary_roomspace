// app/javascript/packs/application.js

// Ensure you import only necessary libraries and avoid conflicts
import Rails from "@rails/ujs";
import { Turbo } from "@hotwired/turbo-rails";

// Initialize Rails UJS
Rails.start();

// Initialize Turbo
Turbo.start();

// Add any custom JavaScript below
