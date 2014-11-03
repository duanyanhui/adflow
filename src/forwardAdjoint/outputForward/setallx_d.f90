   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
   !
   !  Differentiation of setallx in forward (tangent) mode (with options i4 dr8 r8):
   !   Plus diff mem management of: x:in x0:in-out x1:in-out x2:in-out
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          setallx.f90                                     *
   !      * Author:        Peter Zhoujie Lyu                               *
   !      * Starting date: 11-03-2014                                      *
   !      * Last modified: 11-03-2014                                      *
   !      *                                                                *
   !      ******************************************************************
   SUBROUTINE SETALLX_D(nn, x0, x0d, x1, x1d, x2, x2d)
   USE BCTYPES
   USE BLOCKPOINTERS_D
   IMPLICIT NONE
   !
   !      Subroutine arguments.
   !
   INTEGER(kind=inttype), INTENT(IN) :: nn
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: x0, x1, x2
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: x0d, x1d, x2d
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Determine the face id on which the subface is located and set
   ! the pointers accordinly.
   SELECT CASE  (bcfaceid(nn)) 
   CASE (imin) 
   x0d => xd(0, :, :, :)
   x0 => x(0, :, :, :)
   x1d => xd(1, :, :, :)
   x1 => x(1, :, :, :)
   x2d => xd(2, :, :, :)
   x2 => x(2, :, :, :)
   CASE (imax) 
   !===========================================================
   x0d => xd(ie, :, :, :)
   x0 => x(ie, :, :, :)
   x1d => xd(il, :, :, :)
   x1 => x(il, :, :, :)
   x2d => xd(nx, :, :, :)
   x2 => x(nx, :, :, :)
   CASE (jmin) 
   !===========================================================
   x0d => xd(:, 0, :, :)
   x0 => x(:, 0, :, :)
   x1d => xd(:, 1, :, :)
   x1 => x(:, 1, :, :)
   x2d => xd(:, 2, :, :)
   x2 => x(:, 2, :, :)
   CASE (jmax) 
   !===========================================================
   x0d => xd(:, je, :, :)
   x0 => x(:, je, :, :)
   x1d => xd(:, jl, :, :)
   x1 => x(:, jl, :, :)
   x2d => xd(:, ny, :, :)
   x2 => x(:, ny, :, :)
   CASE (kmin) 
   !===========================================================
   x0d => xd(:, :, 0, :)
   x0 => x(:, :, 0, :)
   x1d => xd(:, :, 1, :)
   x1 => x(:, :, 1, :)
   x2d => xd(:, :, 2, :)
   x2 => x(:, :, 2, :)
   CASE (kmax) 
   !===========================================================
   x0d => xd(:, :, ke, :)
   x0 => x(:, :, ke, :)
   x1d => xd(:, :, kl, :)
   x1 => x(:, :, kl, :)
   x2d => xd(:, :, nz, :)
   x2 => x(:, :, nz, :)
   END SELECT
   END SUBROUTINE SETALLX_D
