! T. J Newman, Tempe, July 2010

module scem_2_integrate

  use scem_0_arrays
  use scem_0_input
  use scem_0_ran_array
  use scem_0_useful
  use scem_1_types
  use scem_2_background
  use scem_2_DIT
  use scem_2_1_near_neighbour_update
  use scem_2_1_cortical_tension_update

  implicit none

  contains

    subroutine scem_integrate

      !Update element velocities according to standard near neighbour interactions.
      call scem_near_neighbour_update

      !Update cortex element velocities according to cortex interaction network.
      if (flag_cortex.EQ.1) then
        if (flag_DIT.EQ.1) then
          call scem_dit
        endif
        call scem_cortical_tension_update
      endif

      !Update element velocities according to background potential.
      if (flag_background.GT.0) then
        call scem_background
      end if

    end subroutine scem_integrate

end module scem_2_integrate