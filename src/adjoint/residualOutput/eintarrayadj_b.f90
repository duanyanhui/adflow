   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
   !  
   !  Differentiation of eintarrayadj in reverse (adjoint) mode:
   !   gradient, with respect to input variables: k p eint rho gammaconstant
   !   of linear combination of output variables: p eint rho
   !      ==================================================================
   SUBROUTINE EINTARRAYADJ_B(rho, rhob, p, pb, k, kb, eint, eintb, &
   &  correctfork, kk)
   USE constants
   USE cpcurvefits
   USE flowvarrefstate
   USE inputphysics
   IMPLICIT NONE
   LOGICAL, INTENT(IN) :: correctfork
   INTEGER(KIND=INTTYPE), INTENT(IN) :: kk
   REAL(KIND=REALTYPE) :: eint(kk), eintb(kk)
   REAL(KIND=REALTYPE), DIMENSION(kk), INTENT(IN) :: k
   REAL(KIND=REALTYPE), DIMENSION(kk), INTENT(IN) :: p
   REAL(KIND=REALTYPE) :: kb(kk), pb(kk), rhob(kk)
   REAL(KIND=REALTYPE), DIMENSION(kk), INTENT(IN) :: rho
   REAL(KIND=REALTYPE), PARAMETER :: twothird=two*third
   INTEGER(KIND=INTTYPE) :: i, ii, mm, nn, start
   REAL(KIND=REALTYPE) :: factk, ovgm1, pp, scale, t, t2
   REAL(KIND=REALTYPE) :: tempb
   !
   !      ******************************************************************
   !      *                                                                *
   !      * EintArray computes the internal energy per unit mass from the  *
   !      * given density and pressure (and possibly turbulent energy) for *
   !      * the given kk elements of the arrays.                           *
   !      * For a calorically and thermally perfect gas the well-known     *
   !      * expression is used; for only a thermally perfect gas, cp is a  *
   !      * function of temperature, curve fits are used and a more        *
   !      * complex expression is obtained.                                *
   !      *                                                                *
   !      ******************************************************************
   !
   !
   !      Subroutine arguments.
   !
   !!$       real(kind=realType), dimension(*), intent(in)  :: rho, p, k
   !!$       real(kind=realType), dimension(*), intent(out) :: eint
   !
   !      Local parameter.
   !
   !
   !      Local variables.
   !
   !!$           ! Loop over the number of elements of the array
   !!$
   !!$           do i=1,kk
   !!$
   !!$             ! Compute the dimensional temperature.
   !!$
   !!$             pp = p(i)
   !!$             if( correctForK ) pp = pp - twoThird*rho(i)*k(i)
   !!$             t = Tref*pp/(RGas*rho(i))
   !!$
   !!$             ! Determine the case we are having here.
   !!$
   !!$             if(t <= cpTrange(0)) then
   !!$
   !!$               ! Temperature is less than the smallest temperature
   !!$               ! in the curve fits. Use extrapolation using
   !!$               ! constant cv.
   !!$
   !!$               eint(i) = scale*(cpEint(0) + cv0*(t - cpTrange(0)))
   !!$
   !!$             else if(t >= cpTrange(cpNparts)) then
   !!$
   !!$               ! Temperature is larger than the largest temperature
   !!$               ! in the curve fits. Use extrapolation using
   !!$               ! constant cv.
   !!$
   !!$               eint(i) = scale*(cpEint(cpNparts) &
   !!$                       +        cvn*(t - cpTrange(cpNparts)))
   !!$
   !!$             else
   !!$
   !!$               ! Temperature is in the curve fit range.
   !!$               ! First find the valid range.
   !!$
   !!$               ii    = cpNparts
   !!$               start = 1
   !!$               interval: do
   !!$
   !!$                 ! Next guess for the interval.
   !!$
   !!$                 nn = start + ii/2
   !!$
   !!$                 ! Determine the situation we are having here.
   !!$
   !!$                 if(t > cpTrange(nn)) then
   !!$
   !!$                   ! Temperature is larger than the upper boundary of
   !!$                   ! the current interval. Update the lower boundary.
   !!$
   !!$                   start = nn + 1
   !!$                   ii    = ii - 1
   !!$
   !!$                 else if(t >= cpTrange(nn-1)) then
   !!$
   !!$                   ! This is the correct range. Exit the do-loop.
   !!$
   !!$                   exit
   !!$
   !!$                 endif
   !!$
   !!$                 ! Modify ii for the next branch to search.
   !!$
   !!$                 ii = ii/2
   !!$
   !!$               enddo interval
   !!$
   !!$               ! Nn contains the correct curve fit interval.
   !!$               ! Integrate cv to compute eint.
   !!$
   !!$               eint(i) = cpTempFit(nn)%eint0 - t
   !!$               do ii=1,cpTempFit(nn)%nterm
   !!$                 if(cpTempFit(nn)%exponents(ii) == -1_intType) then
   !!$                   eint(i) = eint(i) &
   !!$                           + cpTempFit(nn)%constants(ii)*log(t)
   !!$                 else
   !!$                   mm   = cpTempFit(nn)%exponents(ii) + 1
   !!$                   t2   = t**mm
   !!$                   eint(i) = eint(i) &
   !!$                           + cpTempFit(nn)%constants(ii)*t2/mm
   !!$                 endif
   !!$               enddo
   !!$
   !!$               eint(i) = scale*eint(i)
   !!$
   !!$             endif
   !!$
   !!$             ! Add the turbulent energy if needed.
   !!$
   !!$             if( correctForK ) eint(i) = eint(i) + k(i)
   !!$
   !!$           enddo
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Determine the cp model used in the computation.
   SELECT CASE  (cpmodel) 
   CASE (cpconstant) 
   ! Abbreviate 1/(gamma -1) a bit easier.
   ovgm1 = one/(gammaconstant-one)
   ! Second step. Correct the energy in case a turbulent kinetic
   ! energy is present.
   IF (correctfork) THEN
   factk = ovgm1*(five*third-gammaconstant)
   kb(1:kk) = 0.0
   DO i=kk,1,-1
   kb(i) = kb(i) - factk*eintb(i)
   END DO
   ELSE
   kb(1:kk) = 0.0
   END IF
   DO i=kk,1,-1
   tempb = ovgm1*eintb(i)/rho(i)
   pb(i) = pb(i) + tempb
   rhob(i) = rhob(i) - p(i)*tempb/rho(i)
   eintb(i) = 0.0
   END DO
   CASE (cptempcurvefits) 
   kb(1:kk) = 0.0
   CASE DEFAULT
   kb(1:kk) = 0.0
   END SELECT

   END SUBROUTINE EINTARRAYADJ_B
