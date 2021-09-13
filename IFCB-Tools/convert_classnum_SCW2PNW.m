function [ classnum ] = convert_classnum_SCW2PNW( Z )
%function [ SCWclass ] = convert_classnum_SCW2PNW( PNWclass )
% replace old SCW classnums with new PNW classnums
% to merge training set
% Z input: any SCW classlist
% classnum output: conversion to PNW classlist
%  Alexis D. Fischer, NOAA, September 2021

% %test
%Z=[63;33];

SCW_old=[33	71	73	34	72	49	85	70	65	2	63	3	54	35	58	24	31	36	86	4	94	64	82	67	37	5	62	80	26	74	77	25	55	38	95	52	59	6	76	7	8	53	9	27	39	40	75	10	11	60	12	13	66	28	14	90	84	61	68	15	41	16	51	17	93	32	83	42	78	18	81	43	44	92	45	19	46	47	30	50	20	56	29	89	21	22	91	87	88	48	23	69	1	79	96	57];
PNW_new=[3	5	5	5	5	1	9	38	38	13	14	16	17	18	19	20	74	22	23	23	25	26	27	28	29	30	32	1	1	35	1	1	38	39	40	41	43	45	1	47	48	53	1	1	55	56	57	58	59	1	65	66	67	1	69	72	1	1	74	1	77	78	1	80	1	81	1	82	84	85	86	87	89	90	92	93	94	1	1	1	99	1	1	102	103	104	106	107	108	109	110	1	1	111	1	112];

classnum=changem(Z,PNW_new,SCW_old);

end