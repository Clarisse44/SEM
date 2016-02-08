! T. J Newman, Tempe, July 2010

module scem_0_ran_array

  implicit none

  ! rng is "ran" fortran 90 random number generator from Numerical Recipes
  real, external :: rng
  
  contains

    ! create array of uniform random numbers
    subroutine ran_array(rap,nrow,ncol,iseed)
      real, intent(out) :: rap(:,:)
      integer, intent(in) :: nrow,ncol,iseed
      integer :: i,j

      do i=1,nrow
         do j=1,ncol
            rap(i,j)=rng(iseed)
         end do
      end do
      
    end subroutine ran_array

end module scem_0_ran_array

