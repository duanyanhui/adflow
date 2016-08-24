!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
!  differentiation of bcturbtreatment in reverse (adjoint) mode (with options i4 dr8 r8 noisize):
!   gradient     of useful results: winf *bvtj1 *bvtj2 *w *rlv
!                *bvtk1 *bvtk2 *d2wall *bvti1 *bvti2
!   with respect to varying inputs: winf *w *rlv *d2wall
!   plus diff mem management of: bvtj1:in bvtj2:in w:in rlv:in
!                bvtk1:in bvtk2:in d2wall:in bvti1:in bvti2:in
!                bcdata:in
!
!      ******************************************************************
!      *                                                                *
!      * file:          bcturbtreatment.f90                             *
!      * author:        georgi kalitzin, edwin van der weide            *
!      *                seonghyeon hahn                                 *
!      * starting date: 06-13-2003                                      *
!      * last modified: 08-12-2005                                      *
!      *                                                                *
!      ******************************************************************
!
subroutine bcturbtreatment_b()
!
!      ******************************************************************
!      *                                                                *
!      * bcturbtreatment sets the arrays bmti1, bvti1, etc, such that   *
!      * the physical boundary conditions are treated correctly.        *
!      * it is assumed that the variables in blockpointers already      *
!      * point to the correct block.                                    *
!      *                                                                *
!      * the turbulent variable in the halo is computed as follows:     *
!      * whalo = -bmt*winternal + bvt for every block facer. as it is   *
!      * possible to have a coupling in the boundary conditions bmt     *
!      * actually are matrices. if there is no coupling between the     *
!      * boundary conditions of the turbulence equations bmt is a       *
!      * diagonal matrix.                                               *
!      *                                                                *
!      ******************************************************************
!
  use bctypes
  use blockpointers
  use flowvarrefstate
  implicit none
!
!      local variable.
!
  integer(kind=inttype) :: nn, i, j, k, l, m
  integer :: branch
! loop over the boundary condition subfaces of this block.
bocos:do nn=1,nbocos
! determine the kind of boundary condition for this subface.
    select case  (bctype(nn)) 
    case (nswalladiabatic, nswallisothermal) 
      call pushcontrol2b(2)
    case (symm, symmpolar, eulerwall) 
      call pushcontrol2b(3)
    case (farfield) 
      call pushcontrol2b(1)
    case (slidinginterface, oversetouterbound, domaininterfaceall, &
&   domaininterfacerhouvw, domaininterfacep, domaininterfacerho, &
&   domaininterfacetotal) 
      call pushcontrol2b(0)
    case default
      call pushcontrol2b(3)
    end select
  end do bocos
  do nn=nbocos,1,-1
    call popcontrol2b(branch)
    if (branch .lt. 2) then
      if (branch .eq. 0) then
        call bcturbinterface_b(nn)
      else
        call bcturbfarfield_b(nn)
      end if
    else if (branch .eq. 2) then
      call bcturbwall_b(nn)
    end if
  end do
end subroutine bcturbtreatment_b
