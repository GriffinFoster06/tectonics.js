#include "precompiled/shaders/vertex/template.glsl"

float lon(vec3 pos) {
    return atan(-pos.z, pos.x) + PI;
}
float lat(vec3 pos) {
    return asin(pos.y / length(pos));
}

const float MAX_MERCATOR_LAT = 85.05112878 * PI / 180.0;

float mercator_y(float latitude) {
    float clamped = clamp(latitude, -MAX_MERCATOR_LAT, MAX_MERCATOR_LAT);
    return log(tan(PI / 4.0 + clamped / 2.0));
}

void main() {
    displacement_v = displacement;
    gradient_v = gradient;
    plant_coverage_v = plant_coverage;
    snow_coverage_v = snow_coverage;
    surface_temperature_v = surface_temperature;
    scalar_v = scalar;
    vector_fraction_traversed_v = vector_fraction_traversed;
    position_v = modelMatrix * vec4( position, 1.0 );
    
    float index_offset = map_projection_offset;
    float focus = lon(cameraPosition) + index_offset;
    float lon_focused = mod(lon(position_v.xyz) - focus, 2.*PI) - PI + index_offset;
    float lat_focused = lat(position_v.xyz);

    float height = displacement > sealevel? 0.005 : 0.0;
    float max_y = mercator_y(MAX_MERCATOR_LAT);
    gl_Position = vec4(
        lon_focused / PI,
        mercator_y(lat_focused) / max_y, 
        -height, 
        1);
    
    view_direction_v = -position_v.xyz;
    view_direction_v.y = 0.;
    view_direction_v = normalize(view_direction_v);
    
    view_origin_v = view_matrix_inverse[3].xyz * reference_distance;
    view_origin_v.y = 0.;
    view_origin_v = normalize(view_origin_v);
}
