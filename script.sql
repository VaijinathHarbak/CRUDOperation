USE [master]
GO
/****** Object:  Database [CRUD]    Script Date: 7/9/2022 12:52:22 AM ******/
CREATE DATABASE [CRUD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CRUD', FILENAME = N'C:\Users\Rabindra\CRUD.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CRUD_log', FILENAME = N'C:\Users\Rabindra\CRUD_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CRUD] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CRUD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CRUD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CRUD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CRUD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CRUD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CRUD] SET ARITHABORT OFF 
GO
ALTER DATABASE [CRUD] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CRUD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CRUD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CRUD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CRUD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CRUD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CRUD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CRUD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CRUD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CRUD] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CRUD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CRUD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CRUD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CRUD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CRUD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CRUD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CRUD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CRUD] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CRUD] SET  MULTI_USER 
GO
ALTER DATABASE [CRUD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CRUD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CRUD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CRUD] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CRUD] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CRUD] SET QUERY_STORE = OFF
GO
USE [CRUD]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [CRUD]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 7/9/2022 12:52:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentKey] [int] NOT NULL,
	[DepartmentName] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 7/9/2022 12:52:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[EmailId] [nvarchar](200) NULL,
	[PhoneNumber] [bigint] NULL,
	[Address] [nvarchar](250) NOT NULL,
	[Department] [nvarchar](200) NULL,
	[DepartmentId] [int] NULL,
	[Salary] [money] NULL,
 CONSTRAINT [Employee_pk] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[insert_update_delete]    Script Date: 7/9/2022 12:52:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--drop procedure [dbo].[insert_update_delete];

CREATE   PROCEDURE [dbo].[insert_update_delete] (
	@EmployeeId      int,
	@FirstName   NVARCHAR(20) = null,
	@LastName   NVARCHAR(20) = null,
	@EmailId NVarchar(200) = null,
	@PhoneNumber bigint = null,
	@Department NVarchar(200) = null,
	@DepartmentId int = null,
	@salary        decimal(10, 2) = null,
	@Address          NVARCHAR(250) = null,
	@StatementType NVARCHAR(20)
)
AS
  BEGIN
      IF @StatementType = 'Insert'
        BEGIN
            INSERT INTO employee
                        (
                         FirstName,
                         LastName,
						 EmailId,
						 PhoneNumber,
						 Address,
						 Department,
						 DepartmentId,
                         salary
                         )
            VALUES     ( 
						
						@FirstName,
                         @LastName,
						 @EmailId,
						 @PhoneNumber,
						 @Address,
						 @Department,
						 @DepartmentId,
                         @salary)
        END

     ELSE IF @StatementType = 'Select'
        BEGIN
            SELECT *
            FROM   employee where EmployeeId = case when isnull(@EmployeeId,0) = 0 then EmployeeId else @EmployeeId end
        END

     ELSE IF @StatementType = 'Update'
        BEGIN
            UPDATE employee
            SET    FirstName = Isnull(@FirstName,FirstName),
                   LastName = Isnull(@LastName,LastName),
                   salary = Isnull(@salary,salary),
                    EmailId = Isnull( @EmailId,EmailId),
					PhoneNumber = Isnull(@PhoneNumber,PhoneNumber),
					Address = Isnull(@Address,Address),
					Department = Isnull(@Department,Department),
					DepartmentId = Isnull(@DepartmentId ,DepartmentId)

            WHERE  EmployeeId = @EmployeeId
        END
      ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM employee
            WHERE  EmployeeId = @EmployeeId
        END
  END
GO
/****** Object:  StoredProcedure [dbo].[SP_Employee_List]    Script Date: 7/9/2022 12:52:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Employee]    Script Date: 7/3/2022 6:42:34 PM ******/



CREATE PROCEDURE [dbo].[SP_Employee_List]  
AS  
   BEGIN  
   SELECT EmployeeId  
         ,FirstName 
         ,LastName
		 ,EmailId
		 ,PhoneNumber
		 ,Address
		 ,Department
		 ,DepartmentId
		 ,Salary
   FROM Employee  
END 
GO
USE [master]
GO
ALTER DATABASE [CRUD] SET  READ_WRITE 
GO
