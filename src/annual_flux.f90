PROGRAM annual_flux

	IMPLICIT NONE
	CHARACTER(200) :: buffer, buffer1,filename
	INTEGER :: error
	INTEGER :: month, year
	INTEGER :: arg_count, i

	TYPE :: input
		INTEGER :: fid
		CHARACTER(200) :: filename
	END TYPE input

	TYPE(input) :: files(10)

	arg_count = command_argument_count()

	IF (arg_count < 1) THEN
		WRITE(*,*) "Error! Please read README file!"
		GOTO 1000
	END IF

	CALL get_command_argument(1, buffer)		! Read year and month from command line

	READ(buffer(1:4),*) year

	WRITE(filename,"(I4.4,'-','flux.dat')") year

	DO i = 4, 12 				! Read input file names from command line
		files(i)%fid = i*100
		WRITE(files(i)%filename,"(I4.4,'-',I2.2,'/',I4.4,'-',I2.2,'-flux.dat')") year, i, year, i
	END DO

	! Open output file and write file headers

	OPEN(UNIT=50,FILE=filename,ACTION='write',IOSTAT=error)
	IF (error/=0) GOTO 1000

	WRITE(*,*)"\n  Start reading in file ... \n"
  
	DO i = 4, 4
		OPEN(UNIT=files(i)%fid,FILE=TRIM(ADJUSTL(files(i)%filename)),ACTION='read',IOSTAT=error)
		IF (error/=0) goto 1000

		WRITE(*,"('\n  Reading ',A,'...\n')") TRIM(ADJUSTL(files(i)%filename))

		READ(files(i)%fid,*) buffer
		READ(files(i)%fid,*) buffer
		READ(files(i)%fid,*) buffer
		READ(files(i)%fid,*) buffer

		READ(files(i)%fid,*) buffer, buffer1
		WRITE(*,*) buffer, buffer1
		CLOSE(files(i)%fid)
	END DO

	WRITE(*,*)"\n  done.\n"

1000 CONTINUE

END
