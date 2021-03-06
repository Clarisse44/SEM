!C.K. Revell October 2015
!Module to control background potential for ScEM system

module scem_2_background

  use scem_0_input
  use scem_1_types

  implicit none

contains

  subroutine scem_background(n)
    integer:: n
    if (n.EQ.1) then
      call scem_background1
    elseif (n.EQ.2) then
      call scem_background2
    else
      !Do nothing
    endif
  end subroutine

  subroutine scem_background1
    !Spherical potential well. Returning force outside a radius calculated from the total system volume. No force within that radius.

    real*8  :: spherical_radius    !Radius of element relative to centre of spherical background potential well
    real*8  :: volume_sum
    integer :: n

    volume_sum = 0
    do n=1, nc
      volume_sum = volume_sum + cells(n)%volume
    enddo
    spherical_boundary_radius = 1.2*(((3.0*volume_sum)/(pi*4.0))**(1.0/3.0)) !Boundary radius scales with total system volume
    do n=1, ne
      spherical_radius = DOT_PRODUCT(elements(n)%position,elements(n)%position)
      if (spherical_radius.gt.spherical_boundary_radius) then
        elements(n)%velocity(:) = elements(n)%velocity(:) - 0.1*stiffness_factor*elements(n)%position(:)/spherical_radius    !Constant potential beyond boundary
      endif
    enddo
  end subroutine

  subroutine scem_background2
    !Spherical cap boundary

    real*8              :: volume_sum
    real*8              :: cap_element_radius
    real*8,dimension(3) :: cap_radial_vector
    integer             :: n

    volume_sum = 0
    do n=1, nc
      volume_sum = volume_sum + cells(n)%volume
    enddo

    cap_radius = (81.0*volume_sum/28.0)**(1.0/3.0)
    h          = 2.0*cap_radius/3.0

    do n=1, ne
      cap_radial_vector(1) = elements(n)%position(1)
      cap_radial_vector(2) = elements(n)%position(2)
      cap_radial_vector(3) = elements(n)%position(3) + cap_radius - 0.5*h
      cap_element_radius = dot_product(cap_radial_vector,cap_radial_vector)
      if (elements(n)%position(3).LT.(-0.5*h)) then
        elements(n)%velocity(3) = elements(n)%velocity(3) + 0.1
      elseif (cap_element_radius.GT.cap_radius) then
        elements(n)%velocity = elements(n)%velocity - 0.1*cap_radial_vector/cap_element_radius
      else
        CYCLE
      endif
    enddo
  end subroutine

end module scem_2_background
