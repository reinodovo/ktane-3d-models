/* bomb_module
height_above_pcb = Height from the top of the PCB to the top of the module
module_type = 0: main_module, 1: puzzle module, 2: needy module
*/
module bomb_module_top(height_above_pcb, module_type = 0) {
    general_tolerance = 0.4;

    size = 90;
    total_height = 30;
    corner_radius = 2;
    wall_thickness = 2;

    pcb_size = 86;
    pcb_thickness = 1.6;
    pcb_support_thickness = 2;
    
    height = height_above_pcb + pcb_thickness + pcb_support_thickness;

    screw_pillar_size = 7.5;
    screw_pillar_corner_radius = 1;
    screw_pillar_height = height - pcb_thickness - pcb_support_thickness - wall_thickness;
    screw_hole_position = 4;
    screw_hole_depth = 5.8;
    screw_hole_radius = 2.2;

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
            translate([size - status_led_position, size - status_led_position]) cylinder(height, status_led_radius - general_tolerance / 2, status_led_radius - general_tolerance / 2, center = true);
        if (module_type == 2)
            translate([size / 2, size - needy_module_display_position]) cube([needy_module_display_width, needy_module_display_length, height], center = true);
    }
}
