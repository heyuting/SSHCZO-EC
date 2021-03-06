PROGRAM test

	USE time

	IMPLICIT NONE
	TYPE :: Pressuredata
		INTEGER :: time(100000)
		REAL :: pressure(100000)
	END TYPE Pressuredata
	TYPE(Pressuredata) :: Precord
	INTEGER :: rawtime
	REAL :: P
	TYPE(tm) :: timeinfo
	
	timeinfo = tm(2009,5, 1, 0, 30, 0)
	CALL timegm(timeinfo, rawtime) 

	CALL read_pressure_file(Precord)
	CALL read_pressure(Precord, rawtime, P)
	WRITE(*,*) P


END PROGRAM test

SUBROUTINE read_pressure_file(Precord)
	USE time

	IMPLICIT NONE
	TYPE :: Pressuredata
		INTEGER :: time(100000)
		REAL :: pressure(100000)
	END TYPE Pressuredata

	CHARACTER(100) :: buffer
	INTEGER :: RECORD, error
	REAL :: P, H2O1, H2O2, LWS, T1, T2, RH, Rn, PAR
	INTEGER :: ind
	TYPE(tm) :: timeinfo
	TYPE(Pressuredata) :: Precord

	ind = 1
	error = 0

	OPEN(UNIT=600, FILE='CZO_tower_top.dat', ACTION='read',IOSTAT=error)

	IF (error/=0) GOTO 1000

	DO WHILE(.TRUE.)
		READ(600,*,IOSTAT = error) buffer, RECORD, P, H2O1, H2O2, LWS, T1, T2, RH, Rn, PAR
		IF (error < 0 ) THEN
			EXIT
		ELSE IF (error > 0) THEN
			CYCLE
		END IF

		Precord%pressure(ind) = P

		READ(buffer(:4),*) timeinfo%tm_year
		READ(buffer(6:7),*) timeinfo%tm_mon
		READ(buffer(9:10),*) timeinfo%tm_mday
		READ(buffer(12:13),*) timeinfo%tm_hour
		READ(buffer(15:16),*) timeinfo%tm_min
		READ(buffer(18:),*) timeinfo%tm_sec

		CALL timegm(timeinfo, Precord%time(ind))
		ind = ind + 1
	END DO
	CLOSE(600)
1000 CONTINUE
END SUBROUTINE read_pressure_file

SUBROUTINE read_pressure(Precord, time, P)

	IMPLICIT NONE
	TYPE :: Pressuredata
		INTEGER :: time(100000)
		REAL :: pressure(100000)
	END TYPE Pressuredata

	INTEGER :: time
	TYPE(Pressuredata) :: Precord
	REAL :: P
	INTEGER :: counter, i

	counter = 0
	P = 0
	DO i = 1, 100000
		IF (Precord%time(i)>time-60*30 .AND. Precord%time(i)<=time) THEN
			P = P + Precord%pressure(i)
			counter = counter + 1
		ELSE
			IF (Precord%time(i) > time) THEN
				EXIT
			END IF
		END IF
	END DO

	P = P/REAL(counter)

END SUBROUTINE read_pressure
	
