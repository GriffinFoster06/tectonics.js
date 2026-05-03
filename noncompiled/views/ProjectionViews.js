'use strict';

var projectionViews = {};
projectionViews.equirectangular    = new MapProjectionView(vertexShaders.equirectangular);
projectionViews.mercator           = new MapProjectionView(vertexShaders.mercator);
projectionViews.texture            = new MapProjectionView(vertexShaders.texture);
projectionViews.orthographic    = new GlobeProjectionView();
