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