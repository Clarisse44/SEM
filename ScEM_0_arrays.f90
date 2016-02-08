! T. J Newman, Tempe, July 2010

module scem_0_arrays

  implicit none

  ! declare system arrays
  ! note, the relative strength array is declared and allocated in the user-input module
  real*8, allocatable, dimension(:,:)			:: potential_deriv        !potential_deriv tables are filled with gradient of inter-element potentials (ie force)
  real*8, allocatable, dimension(:,:)			:: potential_deriv_2
  real*8, dimension(3)							:: x_cen
  real*8, allocatable, dimension(:,:)			:: xe_compare
  real*8, allocatable, dimension(:,:)			:: xe_prev
  integer, allocatable, dimension(:,:,:)		:: head
  integer, allocatable, dimension(:)			:: list
  integer, allocatable, dimension(:,:)			:: pairs
  integer, allocatable, dimension(:)			:: read_cell_fate !initial fate of cells read from file
  double precision, allocatable, dimension(:,:) :: elements_polar		!Positions of elements in polar coordinates (r,theta,phi) relative to the centre of mass of their cell, as used in scem_cortex
  integer, allocatable, dimension(:,:)			:: neighbours

end module scem_0_arrays
