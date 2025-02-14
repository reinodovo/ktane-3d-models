general_tolerance = 0.4;

size = 90;
total_height = 30;
corner_radius = 2;
wall_thickness = 2;

pcb_size = 86;
pcb_thickness = 1.6;
pcb_support_thickness = 2;

screw_hole_position = 4;
screw_head_hole_radius = 3;
screw_body_hole_radius = 1.5;

screw_hole_depth = 5.8;
screw_hole_radius = 2.2;

peg_radius = 3;
peg_sphere_offset = 1;
peg_length = 10;
peg_thickness = 1.5;
peg_position = 10;
peg_position_height = 5;
peg_hole_tolerance = 1.1;

// Bomb Case
module_hole_tolerance = 1;
back_plate_thickness = 4.5;
screw_hole_offset = 25;

wall_between_modules_thickness = 8; 
wall_between_modules_corner_radius = 1;
wall_between_modules_tolerance = 0.2;
vertical_wall_height = 25;
horizontal_wall_height = 22;

gap = size + module_hole_tolerance + wall_between_modules_thickness;
module_gap = size + module_hole_tolerance;

back_plate_length = (size + module_hole_tolerance) * 3 + wall_between_modules_thickness * 4;
back_plate_width = (size + module_hole_tolerance) * 2 + wall_between_modules_thickness * 3;

outer_wall_thickness = 4;

height_below_back_plate = 10;
height_above_inner_wall = 5;

outer_wall_corner_radius_side = 10;
outer_wall_corner_radius_top = 1.5;

outer_wall_length = back_plate_length + 2 * outer_wall_thickness;
outer_wall_width = back_plate_width + 2 * outer_wall_thickness;
outer_wall_height = height_below_back_plate + back_plate_thickness + height_above_inner_wall + vertical_wall_height;

outer_wall_screw_hole_distance_bottom = 27.5;
outer_wall_screw_hole_distance = 13.5;
outer_wall_screw_hole_distance_corner = 40;

outer_wall_connection_peg_size = 3;
outer_wall_connection_peg_height = 8;
outer_wall_connection_peg_depth = 5;

function height_top(height_above_pcb) = height_above_pcb + pcb_thickness + pcb_support_thickness;
function height_bottom(height_above_pcb) = total_height - height_top(height_above_pcb);

module screw_insert_hole() {
    cylinder(screw_hole_depth, screw_hole_radius, screw_hole_radius);
}

module peg_hole(thickness = 10) {
    cylinder_radius = sqrt(peg_radius * peg_radius - peg_sphere_offset * peg_sphere_offset) + peg_hole_tolerance;

    hull() {
        rotate([0, 90, 0]) cylinder(thickness, cylinder_radius, cylinder_radius, center = true);
        translate([0, 0, - peg_length + 0.5]) cube([thickness, 2 * cylinder_radius, 1], center = true);
    }
}

module peg() {
    cylinder_radius = sqrt(peg_radius * peg_radius - peg_sphere_offset * peg_sphere_offset);

    union() {
        intersection() {
            translate([-peg_sphere_offset, 0, 0]) sphere(peg_radius);
            translate([2 * peg_radius, 0, 0]) cube([4 * peg_radius, 4 * peg_radius, 4 * peg_radius], center = true);
        }
        hull() {
            translate([-peg_thickness / 2, 0, 0]) rotate([0, 90, 0]) cylinder(peg_thickness, cylinder_radius, cylinder_radius, center = true);
            translate([-peg_thickness / 2, 0, - peg_length + 0.5]) cube([peg_thickness, 2 * cylinder_radius, 1], center = true);
        }
    }
}