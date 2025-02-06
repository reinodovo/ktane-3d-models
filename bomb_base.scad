include <variables.scad>

/* bomb_module
height_above_pcb = Height from the top of the PCB to the top of the module
module_type = 0: main_module, 1: puzzle module, 2: needy module
*/
module bomb_module_top(height_above_pcb, module_type = 0) {
    height = height_top(height_above_pcb);

    screw_pillar_size = 7.5;
    screw_pillar_corner_radius = 1;
    screw_pillar_height = height - pcb_thickness - pcb_support_thickness - wall_thickness;

    status_led_radius = 2.5;
    status_led_position = 11;

    needy_module_display_length = 10;
    needy_module_display_width = 15;
    needy_module_display_position = 10;

    difference() {
        translate([0, 0, -height]) union() {
            translate([size / 2, size / 2]) difference() {
                minkowski() {
                    translate([0, 0, (height - corner_radius) / 2]) cube([size - 2 * corner_radius, size - 2 * corner_radius, height - corner_radius], center = true);
                    difference() {
                        sphere(corner_radius);
                        translate([0, 0, -corner_radius]) cube([2 * corner_radius, 2 * corner_radius, 2 * corner_radius], center = true);
                    }
                }
                translate([0, 0, (height - wall_thickness) / 2]) cube([size - 2 * wall_thickness + general_tolerance, size - 2 * wall_thickness + general_tolerance, height - wall_thickness], center = true);
            }
            for (i = [0:1], j = [0,1]) {
                translate([size * i, size * j, 0])
                rotate([0, 0, 90 * i + 90 * j + j * (1 - i) * 180])
                difference() {
                    minkowski() {
                        translate([wall_thickness - general_tolerance / 2, wall_thickness - general_tolerance / 2, pcb_thickness + pcb_support_thickness]) cube([screw_pillar_size - screw_pillar_corner_radius, screw_pillar_size - screw_pillar_corner_radius, screw_pillar_height]);
                        difference() {
                            linear_extrude(wall_thickness / 2) circle(screw_pillar_corner_radius);
                            translate([0, 0, -screw_pillar_corner_radius]) cube([2 * screw_pillar_corner_radius, 2 * screw_pillar_corner_radius, 2 * screw_pillar_corner_radius], center = true);
                            translate([0, -screw_pillar_corner_radius, 0]) cube([2 * screw_pillar_corner_radius, 2 * screw_pillar_corner_radius, 2 * screw_pillar_corner_radius], center = true);
                            translate([-screw_pillar_corner_radius, 0, 0]) cube([2 * screw_pillar_corner_radius, 2 * screw_pillar_corner_radius, 2 * screw_pillar_corner_radius], center = true);
                        }
                    }
                    translate([wall_thickness + screw_hole_position, wall_thickness + screw_hole_position, pcb_thickness + pcb_support_thickness]) cylinder(screw_hole_depth, screw_hole_radius, screw_hole_radius);
                }
            }
        }
        if (module_type == 1)
            translate([size - status_led_position, size - status_led_position]) cylinder(height, status_led_radius + general_tolerance / 2, status_led_radius + general_tolerance / 2, center = true);
        if (module_type == 2)
            translate([size / 2, size - needy_module_display_position]) cube([needy_module_display_width, needy_module_display_length, height], center = true);
    }
}

module peg() {
    translate([-peg_sphere_offset, 0, peg_position_height]) sphere(peg_radius);
}

module bomb_module_bottom(height_above_pcb) {
    height = height_bottom(height_above_pcb);

    connector_tolerance = 0.15;
    connector_length = 11.55;
    connector_width = 5.25;
    connector_position = 30;
    connector_lip_depth = 0.82;
    connector_lip_length = 14.55;
    connector_lip_width = 4.45;
    connector_lip_offset = 0.35;
    connector_side_support_length = 9.45;
    connector_side_support_height = 5;

    pcb_support_wall_thickness = 1;
    pcb_support_size = 9;
    pcb_support_size_above = 8;
    pcb_support_size_above_corner_radius = 1;

    translate([size / 2, size / 2])
    difference() {
        union() {
            difference() {
                minkowski() {
                    translate([0, 0, (height + corner_radius) / 2]) cube([size - 2 * corner_radius, size - 2 * corner_radius, height - corner_radius], center = true);
                    difference() {
                        sphere(corner_radius);
                        translate([0, 0, corner_radius]) cube([2 * corner_radius, 2 * corner_radius, 2 * corner_radius], center = true);
                    }
                }
                translate([0, 0, (height + wall_thickness) / 2]) cube([size - 2 * wall_thickness, size - 2 * wall_thickness, height - wall_thickness], center = true);
                translate([0, -size / 2 + connector_position, 0]) {
                    cube([connector_length + connector_tolerance, connector_width + connector_tolerance, total_height], center = true);
                    translate([0, (connector_width + connector_tolerance - (connector_lip_width + connector_tolerance)) / 2 + connector_lip_offset, total_height / 2 + connector_lip_depth + connector_tolerance / 2]) cube([connector_lip_length + connector_tolerance, connector_lip_width + connector_tolerance, total_height], center = true);
                }
            }
            translate([0, -size / 2 + connector_position + (connector_width + connector_tolerance + wall_thickness) / 2, connector_side_support_height / 2]) {
                cube([connector_side_support_length - connector_tolerance, wall_thickness, connector_side_support_height], center = true);
            }
            for (i = [0:3]) {
                rotate([0, 0, 90 * i]) {
                    translate([-size / 2 + wall_thickness + pcb_support_wall_thickness / 2, 2 -size / 2 + wall_thickness - general_tolerance + size / 4, (height - wall_thickness + pcb_support_thickness - general_tolerance) / 2 + wall_thickness]) cube([pcb_support_wall_thickness, size / 2, height - wall_thickness + pcb_support_thickness - general_tolerance], center = true);
                    translate([2 -size / 2 + wall_thickness - general_tolerance + size / 4, -size / 2 + wall_thickness + pcb_support_wall_thickness / 2, (height - wall_thickness + pcb_support_thickness - general_tolerance) / 2 + wall_thickness]) cube([size / 2, pcb_support_wall_thickness, height - wall_thickness + pcb_support_thickness - general_tolerance], center = true);
                    translate([-size / 2 + wall_thickness + pcb_support_size / 2, -size / 2 + wall_thickness + pcb_support_size / 2, height / 2 + wall_thickness / 2]) cube([pcb_support_size, pcb_support_size, height - wall_thickness], center = true);
                    translate([-size / 2 + wall_thickness + pcb_support_size_above / 2, -size / 2 + wall_thickness + pcb_support_size_above / 2, height + (pcb_support_thickness - general_tolerance) / 2]) minkowski() {
                        translate([pcb_support_size_above_corner_radius / 2, pcb_support_size_above_corner_radius / 2]) cube([pcb_support_size_above - pcb_support_size_above_corner_radius, pcb_support_size_above - pcb_support_size_above_corner_radius, pcb_support_thickness - general_tolerance], center = true);
                        difference() {
                            cylinder(0.0001, pcb_support_size_above_corner_radius, pcb_support_size_above_corner_radius);
                            translate([0, 5, 0]) cube([size, 10, size], center = true);
                            translate([5, 0, 0]) cube([10, size, size], center = true);
                        }
                    } 
                }
            }
        }
        for (i = [0:3]) {
            rotate([0, 0, 90 * i])
            translate([-size / 2 + wall_thickness + screw_hole_position, -size / 2 + wall_thickness + screw_hole_position]) hull() {
                cylinder(1, screw_head_hole_radius, screw_head_hole_radius);
                translate([0, 0, 0.01 + height + pcb_support_thickness - general_tolerance - (screw_head_hole_radius - screw_body_hole_radius)]) cylinder(screw_head_hole_radius - screw_body_hole_radius, screw_head_hole_radius, screw_body_hole_radius);
            }
        }
        for (j = [0:1]) rotate([0, 0, 180 * j]) for (i = [-1:2:1]) translate([-size / 2, i * peg_position, 0]) peg();
    }
}
