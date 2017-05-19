!Module to decouple adhesion magnitude from changes in local element density caused by differential interfacial tension
! CK Revell, November 2016

module scem_2_decouple_adhesion

  use scem_0_input
  use scem_1_types

  implicit none

contains

  subroutine scem_decouple_adhesion

    integer :: element_label,t1,t2,t3,i,j,k
    real*8  :: local_area
    real*8, dimension(3)  :: a,b,c

    !Refresh adhesion factors
    FORALL(i=1:ne) elements(i)%adhesion_factor=1

!    if (mod(time,(output_interval2)).LT.dt) open(unit=31,file=output_folder//"/decouplingareas.txt",position='append')

    do i=1, nc
      do j=1, cells(i)%cortex_elements(0)
        element_label = cells(i)%cortex_elements(j)
        local_area = 0
        do k=1, cells(i)%triplet_count
          !t1,t2, and t3 are labels of elements in triplet k
          t1 = cells(i)%triplets(1,k)
          t2 = cells(i)%triplets(2,k)
          t3 = cells(i)%triplets(3,k)
          if (t1.EQ.element_label.OR.t2.EQ.element_label.OR.t3.EQ.element_label) then !If any of the three elements in this triplet is the same as element_label
            ! a and b are vectors representing two sides of the triangle formed by elements t1, t2, and t3
            a = elements(t1)%position - elements(t2)%position
            b = elements(t1)%position - elements(t3)%position
            c = CROSS_PRODUCT(a,b)
            local_area = local_area + 0.5*SQRT(DOT_PRODUCT(c,c)) !0.5*|axb|
          else
            CYCLE
          endif
        enddo
        !adhesion_factor for this element updated according to the local area around the element.
        elements(element_label)%adhesion_factor = local_area/area_normalisation_factor !Might be worth introducing a constant here so that the adhesion magnitude in scem_input can be maintained as a nice number

  !      if (mod(time,(output_interval2)).LT.dt) write(31,*) ne, local_area


      enddo
    enddo

  end subroutine scem_decouple_adhesion

end module scem_2_decouple_adhesion
