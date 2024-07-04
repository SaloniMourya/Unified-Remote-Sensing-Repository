/*
** Author: Saloni Mourya & Rishitha Bejjanki
** Course: IFT/530
** SQL Server Version: Microsoft SQL Server 2012 (SP1) 
** History
** Date Created    Comments
** 04/23/2024      Final Project
*/
CREATE DATABASE Team26
GO 

USE Team26
GO


------------------------------------Creating Tables--------------------------------------------------------------------

-- Create Sensor_Details table
CREATE TABLE Sensor_Details (
    sensor_id INT PRIMARY KEY,
    sensor_name VARCHAR(100) NOT NULL,
    sensor_type VARCHAR(100) NOT NULL,
    spectral_range VARCHAR(100), 
    resolution NUMERIC NOT NULL CHECK (resolution > 0),
    vendor VARCHAR(100) 
);



-- Create Data_Providers table
CREATE TABLE Data_Providers (
    provider_id INT NOT NULL PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL 
);


-- Create Satellite_Imagery table
CREATE TABLE Satellite_Imagery (
    satellite_id INT NOT NULL,
    satellite_name VARCHAR(100) NOT NULL, -- Adjusted to VARCHAR(100)
    capture_date DATE NOT NULL,
    sensor_id INT NOT NULL,
    resolution NUMERIC NOT NULL CHECK (resolution > 0),
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    cloud_cover_percentage NUMERIC,
    sun_angle NUMERIC,
    processing_status VARCHAR(20), -- Adjusted to VARCHAR(20)
    provider_id INT NOT NULL,
    PRIMARY KEY (satellite_id),
    FOREIGN KEY (sensor_id) REFERENCES Sensor_Details(sensor_id),
    FOREIGN KEY (provider_id) REFERENCES Data_Providers(provider_id)
);


-- Create Aerial_Photography table
CREATE TABLE Aerial_Photography (
    photo_id INT PRIMARY KEY,
    flight_date DATE NOT NULL,
    camera_type VARCHAR(20) NOT NULL, -- Adjust the length as per your requirements
    altitude NUMERIC NOT NULL CHECK (altitude > 0),
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    aircraft_details TEXT,
    processing_details TEXT,
    provider_id INT NOT NULL,
    FOREIGN KEY (provider_id) REFERENCES Data_Providers(provider_id)
);

-- Create Environmental_Parameters table
CREATE TABLE Environmental_Parameters (
    parameter_id INT PRIMARY KEY,
    parameter_name VARCHAR(100) NOT NULL,
    value NUMERIC NOT NULL,
    unit VARCHAR(50) NOT NULL,
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    satellite_id INT NOT NULL,
    FOREIGN KEY (satellite_id) REFERENCES Satellite_Imagery(satellite_id)
);
-- Create Geospatial_Data table
CREATE TABLE Geospatial_Data (
    data_id INT PRIMARY KEY,
    data_type VARCHAR(100) NOT NULL,
    source VARCHAR(100) NOT NULL,
    description TEXT,
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    satellite_id INT NOT NULL,
    FOREIGN KEY (satellite_id) REFERENCES Satellite_Imagery(satellite_id),
);



-- Create Image_Processing_Log table
CREATE TABLE Image_Processing_Log (
    log_id INT PRIMARY KEY,
    image_id INT NOT NULL,
    process_date DATE NOT NULL,
    process_type VARCHAR(20) NOT NULL, -- Adjusted length for process_type
    processor_name VARCHAR(50) NOT NULL, -- Adjusted length for processor_name
    FOREIGN KEY (image_id) REFERENCES Satellite_Imagery(satellite_id)
);

-- Create Region_Boundaries table
CREATE TABLE Region_Boundaries (
    boundary_id INT PRIMARY KEY,
    region_name VARCHAR(255) NOT NULL,
    boundary_type VARCHAR(255) NOT NULL,
    boundary_geometry GEOMETRY NOT NULL,
    satellite_id INT NOT NULL,
    FOREIGN KEY (satellite_id) REFERENCES Satellite_Imagery(satellite_id)
);





----------------------------------------------Data insertion----------------------------------------------------------------------

-- dimension tables
INSERT INTO Sensor_Details (sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor)
VALUES
(1, 'Landsat-8 OLI', 'Optical', 'Visible, Near-infrared, Short-wave infrared', 30.0, 'USGS'),
(2, 'Sentinel-2 MSI', 'Multispectral', 'Visible, Near-infrared, Short-wave infrared', 10.0, 'ESA'),
(3, 'MODIS', 'Multispectral', 'Visible, Near-infrared, Thermal', 250.0, 'NASA'),
(4, 'ASTER', 'Multispectral', 'Visible, Near-infrared, Thermal', 15.0, 'NASA'),
(5, 'WorldView-3', 'Panchromatic', 'Visible', 3.31, 'Maxar'),
(6, 'GOES-16 ABI', 'Imaging', 'Visible, Infrared', 2.0, 'NOAA'),
(7, 'RADARSAT-2', 'SAR', 'Microwave', 8.0, 'MDA'),
(8, 'Hyperspectral', 'Hyperspectral', 'Visible, Near-infrared, Infrared', 1.0, 'Specim'),
(9, 'Pleiades', 'Optical', 'Visible, Near-infrared', 5.5, 'Airbus'),
(10, 'TerraSAR-X', 'SAR', 'Microwave', 1.0, 'DLR');
Select * from Sensor_Details



INSERT INTO Data_Providers (provider_id, provider_name, contact_person, email, phone_number)
VALUES
(101, 'NASA', 'John Smith', 'john.smith@nasa.gov', '+1 (123) 456-7890'),
(102, 'European Space Agency', 'Emma Johnson', 'emma.johnson@esa.int', '+33 (0)1 53 69 76 54'),
(103, 'Maxar Technologies', 'Michael Brown', 'michael.brown@maxar.com', '+1 (987) 654-3210'),
(104, 'Korea Aerospace Research Institute', 'David Lee', 'david.lee@kari.re.kr', '+82 42 860 2202'),
(105, 'Specim', 'Laura White', 'laura.white@specim.fi', '+358 9 5617 3700'),
(106, 'Canadian Space Agency', 'Sophie Martin', 'sophie.martin@asc-csa.gc.ca', '+1 (866) 562-7302'),
(107, 'Japan Ministry of Economy, Trade and Industry', 'Kenji Yamamoto', 'kenji.yamamoto@meti.go.jp', '+81 3 3501 1511'),
(108, 'NOAA', 'Emily Davis', 'emily.davis@noaa.gov', '+1 (301) 713-9434'),
(109, 'SpaceX', 'Alex Turner', 'alex.turner@spacex.com', '+1 (310) 363-6492'),
(110, 'Roscosmos', 'Sergei Ivanov', 'sergei.ivanov@roscosmos.ru', '+7 (495) 631-93-91');
Select * from Data_Providers

--transactional tables
INSERT INTO Aerial_Photography (photo_id, flight_date, camera_type, altitude, latitude, longitude, aircraft_details, processing_details, provider_id)
VALUES
(201, '2024-04-20', 'Digital', 1000, 37.7749, -122.4194, 'Cessna 172', 'Processed using Pix4Dmapper', 101),
(202, '2024-04-18', 'Analog', 1500, 40.7128, -74.0060, 'Piper PA-28', 'Manual stitching', 102),
(203, '2024-04-16', 'Digital', 1200, 34.0522, -118.2437, 'Cessna 206', 'Processed using Agisoft Metashape', 103),
(204, '2024-04-14', 'Analog', 1100, 41.8781, -87.6298, 'Beechcraft Baron', 'Manual stitching', 104),
(205, '2024-04-12', 'Digital', 1300, 51.5074, -0.1278, 'Cessna 172', 'Processed using Pix4Dmapper', 105),
(206, '2024-04-10', 'Analog', 1400, 48.8566, 2.3522, 'Piper PA-28', 'Manual stitching', 106),
(207, '2024-04-08', 'Digital', 1100, 35.6895, 139.6917, 'Cessna 206', 'Processed using Agisoft Metashape', 107),
(208, '2024-04-06', 'Analog', 1200, 37.7749, -122.4194, 'Beechcraft Baron', 'Manual stitching', 108),
(209, '2024-04-04', 'Digital', 1500, 40.7128, -74.0060, 'Cessna 172', 'Processed using Pix4Dmapper', 109),
(210, '2024-04-02', 'Analog', 1000, 34.0522, -118.2437, 'Piper PA-28', 'Manual stitching', 110),
(211, '2024-03-31', 'Digital', 1300, 41.8781, -87.6298, 'Cessna 206', 'Processed using Agisoft Metashape', 101),
(212, '2024-03-29', 'Analog', 1200, 51.5074, -0.1278, 'Beechcraft Baron', 'Manual stitching', 102),
(213, '2024-03-27', 'Digital', 1400, 48.8566, 2.3522, 'Cessna 172', 'Processed using Pix4Dmapper', 103),
(214, '2024-03-25', 'Analog', 1100, 35.6895, 139.6917, 'Piper PA-28', 'Manual stitching', 104),
(215, '2024-03-23', 'Digital', 1000, 37.7749, -122.4194, 'Cessna 206', 'Processed using Agisoft Metashape', 105),
(216, '2024-03-21', 'Analog', 1500, 40.7128, -74.0060, 'Beechcraft Baron', 'Manual stitching', 106),
(217, '2024-03-19', 'Digital', 1200, 34.0522, -118.2437, 'Cessna 172', 'Processed using Pix4Dmapper', 107),
(218, '2024-03-17', 'Analog', 1300, 41.8781, -87.6298, 'Piper PA-28', 'Manual stitching', 108),
(219, '2024-03-15', 'Digital', 1100, 51.5074, -0.1278, 'Cessna 206', 'Processed using Agisoft Metashape', 109),
(220, '2024-03-13', 'Analog', 1200, 48.8566, 2.3522, 'Beechcraft Baron', 'Manual stitching', 110);
Select * from Aerial_Photography



INSERT INTO Satellite_Imagery (
    satellite_id, 
    satellite_name, 
    capture_date, 
    sensor_id, 
    resolution, 
    latitude, 
    longitude, 
    cloud_cover_percentage, 
    sun_angle, 
    processing_status, 
    provider_id
)
VALUES
(1001, 'Satellite-A', '2024-04-20', 1, 30.0, 37.7749, -122.4194, 10.5, 45.0, 'Processed', 101),
(1002, 'Satellite-B', '2024-04-21', 2, 10.0, 40.7128, -74.0060, 5.2, 60.0, 'Processing', 102),
(1003, 'Satellite-C', '2024-04-22', 3, 250.0, 34.0522, -118.2437, 8.0, 30.0, 'Not Processed', 103),
(1004, 'Satellite-D', '2024-04-23', 4, 15.0, 41.8781, -87.6298, 12.0, 75.0, 'Processed', 104),
(1005, 'Satellite-E', '2024-04-24', 5, 3.31, 51.5074, -0.1278, 3.8, 55.0, 'Processing', 105),
(1006, 'Satellite-F', '2024-04-25', 6, 2.0, 48.8566, 2.3522, 6.5, 70.0, 'Not Processed', 106),
(1007, 'Satellite-G', '2024-04-26', 7, 8.0, 35.6895, 139.6917, 9.2, 40.0, 'Processed', 107),
(1008, 'Satellite-H', '2024-04-27', 8, 1.0, 59.3293, 18.0686, 15.0, 80.0, 'Processing', 108),
(1009, 'Satellite-I', '2024-04-28', 9, 5.5, 60.1695, 24.9354, 4.5, 65.0, 'Not Processed', 109),
(1010, 'Satellite-J', '2024-04-29', 10, 1.0, 55.7558, 37.6176, 7.8, 50.0, 'Processed', 110),
(1011, 'Satellite-K', '2024-04-30', 1, 30.0, 34.0522, -118.2437, 8.0, 30.0, 'Not Processed', 101),
(1012, 'Satellite-L', '2024-05-01', 2, 10.0, 40.7128, -74.0060, 5.2, 60.0, 'Processing', 102),
(1013, 'Satellite-M', '2024-05-02', 3, 250.0, 37.7749, -122.4194, 10.5, 45.0, 'Processed', 103),
(1014, 'Satellite-N', '2024-05-03', 4, 15.0, 41.8781, -87.6298, 12.0, 75.0, 'Processed', 104),
(1015, 'Satellite-O', '2024-05-04', 5, 3.31, 51.5074, -0.1278, 3.8, 55.0, 'Processing', 105),
(1016, 'Satellite-P', '2024-05-05', 6, 2.0, 48.8566, 2.3522, 6.5, 70.0, 'Not Processed', 106),
(1017, 'Satellite-Q', '2024-05-06', 7, 8.0, 35.6895, 139.6917, 9.2, 40.0, 'Processed', 107),
(1018, 'Satellite-R', '2024-05-07', 8, 1.0, 59.3293, 18.0686, 15.0, 80.0, 'Processing', 108),
(1019, 'Satellite-S', '2024-05-08', 9, 5.5, 60.1695, 24.9354, 4.5, 65.0, 'Not Processed', 109),
(1020, 'Satellite-T', '2024-05-09', 10, 1.0, 55.7558, 37.6176, 7.8, 50.0, 'Processed', 110),
(1021, 'Satellite-U', '2024-05-10', 1, 30.0, 34.0522, -118.2437, 8.0, 30.0, 'Not Processed', 101),
(1022, 'Satellite-V', '2024-05-11', 2, 10.0, 40.7128, -74.0060, 5.2, 60.0, 'Processing', 102);
Select * from Satellite_Imagery



INSERT INTO Geospatial_Data (
    data_id, 
    data_type, 
    source, 
    description, 
    latitude, 
    longitude, 
    satellite_id
)
VALUES
(441, 'Image', 'Satellite-A', 'Real-time image capture', 37.7749, -122.4194, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-A')),
(442, 'Data', 'Satellite-B', 'Real-time data collection', 40.7128, -74.0060, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-B')),
(443, 'Image', 'Satellite-C', 'Real-time image processing', 34.0522, -118.2437, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-C')),
(444, 'Data', 'Satellite-D', 'Real-time data processing', 41.8781, -87.6298, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-D')),
(445, 'Image', 'Satellite-E', 'Real-time image analysis', 51.5074, -0.1278, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-E')),
(446, 'Data', 'Satellite-F', 'Real-time data analysis', 48.8566, 2.3522, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-F')),
(447, 'Image', 'Satellite-G', 'Real-time image interpretation', 35.6895, 139.6917, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-G')),
(448, 'Data', 'Satellite-H', 'Real-time data interpretation', 59.3293, 18.0686, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-H')),
(449, 'Image', 'Satellite-I', 'Real-time image classification', 60.1695, 24.9354, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-I')),
(450, 'Data', 'Satellite-J', 'Real-time data classification', 55.7558, 37.6176, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-J')),
(451, 'Image', 'Satellite-K', 'Real-time image monitoring', 34.0522, -118.2437, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-K')),
(452, 'Data', 'Satellite-L', 'Real-time data monitoring', 40.7128, -74.0060, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-L')),
(453, 'Image', 'Satellite-M', 'Real-time image tracking', 37.7749, -122.4194, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-M')),
(454, 'Data', 'Satellite-N', 'Real-time data tracking', 41.8781, -87.6298, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-N')),
(455, 'Image', 'Satellite-O', 'Real-time image visualization', 51.5074, -0.1278, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-O')),
(456, 'Data', 'Satellite-P', 'Real-time data visualization', 48.8566, 2.3522, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-P')),
(457, 'Image', 'Satellite-Q', 'Real-time image mapping', 35.6895, 139.6917, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-Q')),
(458, 'Data', 'Satellite-R', 'Real-time data mapping', 59.3293, 18.0686, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-R')),
(459, 'Image', 'Satellite-S', 'Real-time image processing', 60.1695, 24.9354, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-S')),
(460, 'Data', 'Satellite-T', 'Real-time data processing', 55.7558, 37.6176, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-T')),
(461, 'Image', 'Satellite-U', 'Real-time image analysis', 34.0522, -118.2437, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-U')),
(462, 'Data', 'Satellite-V', 'Real-time data analysis', 40.7128, -74.0060, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-V')),
(463, 'Image', 'Satellite-A', 'Real-time image interpretation', 37.7749, -122.4194, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-A')),
(464, 'Data', 'Satellite-B', 'Real-time data interpretation', 40.7128, -74.0060, (SELECT satellite_id FROM Satellite_Imagery WHERE satellite_name = 'Satellite-B'));
Select * from Geospatial_Data




INSERT INTO Region_Boundaries (boundary_id, region_name, boundary_type, boundary_geometry, satellite_id)
VALUES
(552, 'Central Park', 'Park', 'POLYGON ((40.7850 -73.9680, 40.7850 -73.9580, 40.7740 -73.9580, 40.7740 -73.9680, 40.7850 -73.9680))', 1001),
(553, 'Serengeti National Park', 'National Park', 'POLYGON ((-2.3328 34.8888, -2.3328 35.5249, -3.2733 35.5249, -3.2733 34.8888, -2.3328 34.8888))', 1002),
(554, 'Great Barrier Reef', 'Marine Park', 'POLYGON ((-18.2871 147.6991, -18.2871 154.1171, -24.7184 154.1171, -24.7184 147.6991, -18.2871 147.6991))', 1003),
(555, 'Amazon Rainforest', 'Forest Reserve', 'POLYGON ((-3.137 -59.955, -3.137 -59.950, -3.141 -59.950, -3.141 -59.955, -3.137 -59.955))', 1004),
(556, 'Great Wall of China', 'Historical Site', 'LINESTRING (40.4319 116.5704, 40.4319 116.4273)', 1005),
(557, 'Mount Everest', 'Mountain', 'POINT (27.9881 86.9250)', 1006),
(558, 'Victoria Falls', 'Waterfall', 'POINT (-17.9244 25.8567)', 1007),
(559, 'Gobi Desert', 'Desert', 'POLYGON ((42.8855 88.1877, 42.8855 120.1016, 42.2175 120.1016, 42.2175 88.1877, 42.8855 88.1877))', 1008),
(560, 'Niagara Falls', 'Waterfall', 'POINT (43.0782 -79.0758)', 1009),
(561, 'Taj Mahal', 'Historical Site', 'POINT (27.1751 78.0421)', 1010),
(562, 'Galápagos Islands', 'Island', 'MULTIPOINT ((-0.6132 -90.8593), (-0.8406 -91.0684), (-0.5714 -90.3136), (-0.3207 -89.9764), (-0.3804 -89.6498))', 1011),
(563, 'Victoria Peak', 'Mountain', 'POINT (22.2687 114.1531)', 1012),
(564, 'Grand Canyon', 'Canyon', 'POLYGON ((36.1069 -112.1129, 36.1069 -113.2636, 36.9762 -113.2636, 36.9762 -112.1129, 36.1069 -112.1129))', 1013),
(565, 'Mount Kilimanjaro', 'Mountain', 'POINT (-3.0674 37.3556)', 1014),
(566, 'Machu Picchu', 'Historical Site', 'POINT (-13.1631 -72.5450)', 1015),
(567, 'Great Barrier Reef', 'Marine Park', 'POLYGON ((-18.2871 147.6991, -18.2871 154.1171, -24.7184 154.1171, -24.7184 147.6991, -18.2871 147.6991))', 1016),
(568, 'Yellowstone National Park', 'National Park', 'POLYGON ((44.4280 -110.5885, 44.4280 -111.0498, 44.0125 -111.0498, 44.0125 -110.5885, 44.4280 -110.5885))', 1017),
(569, 'Everglades National Park', 'National Park', 'POLYGON ((25.2866 -80.8987, 25.2866 -80.4994, 25.1216 -80.4994, 25.1216 -80.8987, 25.2866 -80.8987))', 1018),
(570, 'Lake Baikal', 'Lake', 'POLYGON ((53.5587 108.1650, 53.5587 109.6007, 51.6650 109.6007, 51.6650 108.1650, 53.5587 108.1650))', 1019),
(571, 'Great Smoky Mountains National Park', 'National Park', 'POLYGON ((35.6554 -83.4681, 35.6554 -83.0265, 35.4676 -83.0265, 35.4676 -83.4681, 35.6554 -83.4681))', 1020),
(572, 'Uluru (Ayers Rock)', 'Rock Formation', 'POINT (-25.3444 131.0369)', 1021);
Select * from Region_Boundaries


INSERT INTO Image_Processing_Log (log_id, image_id, process_date, process_type, processor_name)
VALUES
(7721, 1001, '2024-04-20', 'Preprocessing', 'Processor A'),
(7722, 1002, '2024-04-21', 'Processing', 'Processor B'),
(7723, 1003, '2024-04-22', 'Postprocessing', 'Processor C'),
(7724, 1004, '2024-04-23', 'Preprocessing', 'Processor D'),
(7725, 1005, '2024-04-24', 'Processing', 'Processor E'),
(7726, 1006, '2024-04-25', 'Postprocessing', 'Processor F'),
(7727, 1007, '2024-04-26', 'Preprocessing', 'Processor G'),
(7728, 1008, '2024-04-27', 'Processing', 'Processor H'),
(7729, 1009, '2024-04-28', 'Postprocessing', 'Processor I'),
(7730, 1010, '2024-04-29', 'Preprocessing', 'Processor J'),
(7731, 1011, '2024-04-30', 'Processing', 'Processor K'),
(7732, 1012, '2024-05-01', 'Postprocessing', 'Processor L'),
(7733, 1013, '2024-05-02', 'Preprocessing', 'Processor M'),
(7734, 1014, '2024-05-03', 'Processing', 'Processor N'),
(7735, 1015, '2024-05-04', 'Postprocessing', 'Processor O'),
(7736, 1016, '2024-05-05', 'Preprocessing', 'Processor P'),
(7737, 1017, '2024-05-06', 'Processing', 'Processor Q'),
(7738, 1018, '2024-05-07', 'Postprocessing', 'Processor R'),
(7739, 1019, '2024-05-08', 'Preprocessing', 'Processor S'),
(7740, 1020, '2024-05-09', 'Processing', 'Processor T'),
(7741, 1021, '2024-05-10', 'Postprocessing', 'Processor U'),
(7742, 1022, '2024-05-11', 'Preprocessing', 'Processor V'),
(7743, 1001, '2024-04-20', 'Processing', 'Processor A'),
(7744, 1002, '2024-04-21', 'Postprocessing', 'Processor B'),
(7745, 1003, '2024-04-22', 'Preprocessing', 'Processor C'),
(7746, 1004, '2024-04-23', 'Processing', 'Processor D'),
(7747, 1005, '2024-04-24', 'Postprocessing', 'Processor E');
Select * from Image_Processing_Log



INSERT INTO Environmental_Parameters (parameter_id, parameter_name, value, unit, latitude, longitude, timestamp, satellite_id)
VALUES
(1111, 'Temperature', 25.3, 'Celsius', 37.7749, -122.4194, DEFAULT, 1001),
(1112, 'Humidity', 65.8, 'Percentage', 40.7128, -74.0060, DEFAULT, 1002),
(1113, 'Air Pressure', 1012.5, 'hPa', 34.0522, -118.2437, DEFAULT, 1003),
(1114, 'Wind Speed', 15.2, 'm/s', 41.8781, -87.6298, DEFAULT, 1004),
(1115, 'CO2 Level', 400.0, 'ppm', 51.5074, -0.1278, DEFAULT, 1005),
(1116, 'NO2 Level', 0.02, 'ppm', 48.8566, 2.3522, DEFAULT, 1006),
(1117, 'Ozone Level', 0.03, 'ppm', 35.6895, 139.6917, DEFAULT, 1007),
(1118, 'PM2.5 Level', 10.5, 'µg/m³', 59.3293, 18.0686, DEFAULT, 1008),
(1119, 'UV Index', 8, '', 60.1695, 24.9354, DEFAULT, 1009),
(1120, 'Rainfall', 3.5, 'mm', 55.7558, 37.6176, DEFAULT, 1010),
(1121, 'Temperature', 24.8, 'Celsius', 34.0522, -118.2437, DEFAULT, 1011),
(1122, 'Humidity', 64.2, 'Percentage', 40.7128, -74.0060, DEFAULT, 1012),
(1123, 'Air Pressure', 1013.2, 'hPa', 37.7749, -122.4194, DEFAULT, 1013),
(1124, 'Wind Speed', 16.1, 'm/s', 41.8781, -87.6298, DEFAULT, 1014),
(1125, 'CO2 Level', 410.0, 'ppm', 51.5074, -0.1278, DEFAULT, 1015),
(1126, 'NO2 Level', 0.03, 'ppm', 48.8566, 2.3522, DEFAULT, 1016),
(1127, 'Ozone Level', 0.04, 'ppm', 35.6895, 139.6917, DEFAULT, 1017),
(1128, 'PM2.5 Level', 11.8, 'µg/m³', 59.3293, 18.0686, DEFAULT, 1018),
(1129, 'UV Index', 7, '', 60.1695, 24.9354, DEFAULT, 1019),
(1130, 'Rainfall', 4.2, 'mm', 55.7558, 37.6176, DEFAULT, 1020);
Select * from Environmental_Parameters



-------------------------Views--------------------------------------------------------------------------------
--View 1: Retrieve Processed Satellite Imagery Details by Provider
CREATE VIEW Processed_Satellite_Imagery_View AS
SELECT si.satellite_name, si.capture_date, si.resolution, si.cloud_cover_percentage, si.sun_angle, si.processing_status, dp.provider_name
FROM Satellite_Imagery si
JOIN Data_Providers dp ON si.provider_id = dp.provider_id
WHERE si.processing_status = 'Processed';

Select * from Processed_Satellite_Imagery_View


--View 2: Environmental Parameters by Date Range
CREATE VIEW Environmental_Parameters_Date_Range AS
SELECT ep.parameter_id, ep.parameter_name, ep.value, ep.unit, ep.latitude, ep.longitude, ep.timestamp, si.satellite_name, si.capture_date
FROM Environmental_Parameters ep
JOIN Satellite_Imagery si ON ep.satellite_id = si.satellite_id
WHERE si.capture_date BETWEEN '2024-04-26' AND '2024-05-05';

Select * from Environmental_Parameters_Date_Range


--View 3: Retrieve Environmental Parameters for a Specific Location
CREATE VIEW Environmental_Parameters_For_Location AS
SELECT 
    ep.parameter_name,
    ep.value,
    ep.unit,
    ep.timestamp,
    si.satellite_name
FROM 
    Environmental_Parameters ep
JOIN 
    Satellite_Imagery si ON ep.satellite_id = si.satellite_id
WHERE 
    ep.latitude = 38 AND ep.longitude = -122;

Select * from Environmental_Parameters_For_Location


---------------------------------------------------------Audit table-------------------------------------------------------
-- Create Sensor_Details_Audit table
CREATE TABLE Sensor_Details_Audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    sensor_id INT,
    sensor_name VARCHAR(100) NOT NULL,
    sensor_type VARCHAR(100) NOT NULL,
    spectral_range VARCHAR(100), 
    resolution NUMERIC NOT NULL CHECK (resolution > 0),
    vendor VARCHAR(100),
    action VARCHAR(10) NOT NULL,
    change_datetime DATETIME DEFAULT GETDATE() -- Additional column for datetime field
);

-- Trigger for INSERT operation on Sensor_Details
CREATE TRIGGER tr_Sensor_Details_Insert
ON Sensor_Details
AFTER INSERT
AS
BEGIN
    INSERT INTO Sensor_Details_Audit (sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor, action)
    SELECT sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor, 'INSERTED'
    FROM inserted;
END;
GO

-- Trigger for UPDATE operation on Sensor_Details
CREATE TRIGGER tr_Sensor_Details_Update
ON Sensor_Details
AFTER UPDATE
AS
BEGIN
    INSERT INTO Sensor_Details_Audit (sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor, action)
    SELECT sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor, 'UPDATED'
    FROM inserted;
END;
GO

-- Trigger for DELETE operation on Sensor_Details
CREATE TRIGGER tr_Sensor_Details_Delete
ON Sensor_Details
AFTER DELETE
AS
BEGIN
    INSERT INTO Sensor_Details_Audit (sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor, action)
    SELECT sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor, 'DELETED'
    FROM deleted;
END;
GO



Select * from Sensor_Details

--Testing
-- Insert operation
INSERT INTO Sensor_Details (sensor_id, sensor_name, sensor_type, spectral_range, resolution, vendor)
VALUES (11, 'TerraSAR-XZ', 'SARA', 'Microwave', 4, 'NASA');
Select * from Sensor_Details

-- Update operation
UPDATE Sensor_Details
SET sensor_name = 'UpdatedSensor1'
WHERE sensor_id = 11;
Select * from Sensor_Details

-- Delete operation
DELETE FROM Sensor_Details
WHERE sensor_id = 11;
Select * from Sensor_Details

-- Check audit table
SELECT * FROM Sensor_Details_Audit;


---------------------------------------stored procedures and User Defined Function---------------------------------------------

--create a stored procedure that retrieves all satellite imagery captured on a specific date:
--This stored procedure retrieves all satellite imagery captured on a specific date.
--This stored procedure takes a date parameter (@captureDate) and selects all records from the Satellite_Imagery table where the capture_date matches the provided date.
-- Create the stored procedure
CREATE PROCEDURE GetSatelliteImageryByDate
    @captureDate DATE
AS
BEGIN
    SELECT *
    FROM Satellite_Imagery
    WHERE capture_date = @captureDate;
END;

--create a user-defined function (UDF) that calculates the distance between two geographical points (given their latitudes and longitudes) using the Haversine formula
-- Create the user-defined function (UDF)
CREATE FUNCTION CalculateDistance (
    @lat1 NUMERIC,
    @lon1 NUMERIC,
    @lat2 NUMERIC,
    @lon2 NUMERIC
)
RETURNS NUMERIC
AS
BEGIN
    DECLARE @R NUMERIC = 6371; -- Earth's radius in kilometers

    DECLARE @dLat NUMERIC = RADIANS(@lat2 - @lat1);
    DECLARE @dLon NUMERIC = RADIANS(@lon2 - @lon1);

    DECLARE @a NUMERIC = SIN(@dLat / 2) * SIN(@dLat / 2) +
                         COS(RADIANS(@lat1)) * COS(RADIANS(@lat2)) *
                         SIN(@dLon / 2) * SIN(@dLon / 2);

    DECLARE @c NUMERIC = 2 * ATN2(SQRT(@a), SQRT(1 - @a));

    RETURN @R * @c; -- Distance in kilometers
END;


-- include the scripts to drop these stored procedures and UDFs when they're no longer needed:
-- Drop the stored procedure if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSatelliteImageryByDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSatelliteImageryByDate];

-- Drop the user-defined function (UDF) if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CalculateDistance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CalculateDistance];



------------------------------------------Cursor-----------------------------
-- Create a cursor to fetch data from the Satellite_Imagery table
DECLARE satellite_cursor CURSOR FOR 
SELECT satellite_id, satellite_name, capture_date, sensor_id, resolution, latitude, longitude, cloud_cover_percentage, sun_angle, processing_status, provider_id
FROM Satellite_Imagery;

-- Open the cursor
OPEN satellite_cursor;

-- Fetch the data from the cursor
FETCH NEXT FROM satellite_cursor;

-- Loop through the cursor and print each row
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Satellite ID: ' + CAST(@@FETCH_STATUS AS VARCHAR(10));
    PRINT 'Satellite Name: ' + CAST(@@FETCH_STATUS AS VARCHAR(100));
    -- Add more prints for other columns as needed

    -- Fetch the next row
    FETCH NEXT FROM satellite_cursor;
END

-- Close the cursor
CLOSE satellite_cursor;

-- Deallocate the cursor
DEALLOCATE satellite_cursor;






