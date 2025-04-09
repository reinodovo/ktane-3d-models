include <variables.scad>

/* bomb_module
height_above_pcb = Height from the top of the PCB to the top of the module
module_type = 0: main_module, 1: puzzle module, 2: needy module
*/
module bomb_module_top(height_above_pcb, module_type = 0, ignore_pillars = []) {
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
                if (len(search(i * 2 + j, ignore_pillars)) == 0) {
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

module bomb_module_bottom(height_above_pcb, ignore_pillars = [], skinny_pillars = false) {
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
    pcb_support_size = skinny_pillars ? 8 : 9;
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
            if (len(search(i, ignore_pillars)) == 0) {
                rotate([0, 0, -90 * i])
                translate([-size / 2 + wall_thickness + screw_hole_position, -size / 2 + wall_thickness + screw_hole_position]) hull() {
                    cylinder(1, screw_head_hole_radius, screw_head_hole_radius);
                    translate([0, 0, 0.01 + height + pcb_support_thickness - general_tolerance - (screw_head_hole_radius - screw_body_hole_radius)]) cylinder(screw_head_hole_radius - screw_body_hole_radius, screw_head_hole_radius, screw_body_hole_radius);
                }
            }
        }
        for (j = [0:1]) rotate([0, 0, 180 * j]) for (i = [-1:2:1]) translate([-size / 2, i * peg_position, 0]) peg();
    }
}

/* cylinder button
height_above_module = How much the button pertrudes from the module
height_above_button = Distance from the top of the module to the top of the button
travel_distance = How much the button moves when pressed
radius = Radius of the button
base_radius = Radius of the button bellow the module wall
*/
module cylinder_button(height_above_module = 1, height_above_button = 1 + wall_thickness, radius = 2, base_skirt = 1, corner_radius = 1) {
    tolerance = 0.2;
    height_above = height_above_module + wall_thickness + tolerance;
    height_bellow = height_above_button - wall_thickness - 2 * tolerance;
    union() {
        cylinder(height_bellow, radius + base_skirt, radius + base_skirt);
        translate([0, 0, corner_radius]) minkowski() {
            cylinder(height_above + height_bellow - 2 * corner_radius, radius - corner_radius, radius - corner_radius);
            sphere(corner_radius);
        }
    }
}

module rectangular_button(height_above_module = 1, height_above_button = 1 + wall_thickness, length = 5, width = 5, base_skirt = 1, corner_radius = 1, txt = "TEST", txt_size = 1, txt_depth = 1) {
    tolerance = 0.2;
    height_above = height_above_module + wall_thickness + tolerance;
    height_bellow = height_above_button - wall_thickness - 2 * tolerance;
    difference() {
        union() {
            translate([0, 0, (height_above + height_bellow) / 2]) minkowski() {
                cube([length - 2 * corner_radius, width - 2 * corner_radius, height_above + height_bellow - 2 * corner_radius], center = true);
                sphere(corner_radius);
            }
            translate([0, 0, height_bellow / 2]) cube([length + 2 * base_skirt, width + 2 * base_skirt, height_bellow], center = true);
        }
        translate([0, 0, height_above + height_bellow - txt_depth]) linear_extrude(txt_depth) text(txt, halign = "center", valign = "center", size = txt_size, font = "Arial:style=Bold");
    }
}

module empty_module() {
    height = total_height;

    connector_tolerance = 0.15;
    connector_length = 11.55;
    connector_width = 5.25;
    connector_position = 30;
    connector_depth = 5;

    pcb_support_wall_thickness = 1;
    pcb_support_size = 9;
    pcb_support_size_above = 8;
    pcb_support_size_above_corner_radius = 1;

    detail_large_radius = 4.5 / 2;
    detail_small_radius = 2.9 / 2;
    detail_dist = 4.9 + detail_large_radius / 2;
    detail_small_count = 10;
    detail_small_gap = (size - 2 * detail_dist) / detail_small_count;


    translate([size / 2, size / 2, - total_height])
    union() {
        difference() {
            minkowski() {
                translate([0, 0, (height) / 2]) cube([size - 2 * corner_radius, size - 2 * corner_radius, height - 2 * corner_radius], center = true);
                sphere(corner_radius);
            }
            translate([0, -size / 2 + connector_position, connector_depth / 2]) {
                cube([connector_length + connector_tolerance, connector_width + connector_tolerance, connector_depth], center = true);
            }
            for (j = [0:1]) rotate([0, 0, 180 * j]) for (i = [-1:2:1]) translate([-size / 2, i * peg_position, 0]) peg();
        }
        translate([0, 0, total_height]) {
            for (i = [0:3]) rotate([0, 0, i * 90]) hull() {
                translate([- size / 2 + detail_dist, - size / 2 + detail_dist]) sphere(detail_large_radius);
                translate([- size / 2 + detail_dist, size / 2 - detail_dist]) sphere(detail_large_radius);
            }
            for (i = [0:detail_small_count - 1]) {
                translate([i * detail_small_gap, 0, 0]) hull() {
                    translate([- size / 2 + detail_dist, - size / 2 + detail_dist]) sphere(detail_small_radius);
                    translate([- size / 2 + detail_dist, size / 2 - detail_dist]) sphere(detail_small_radius);
                }
            }
        }
    }
}

$fn = $preview ? 10 : 50;

empty_module();