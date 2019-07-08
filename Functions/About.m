function[]=About()

Aboutf = uifigure('Name','About','NumberTitle','off','Resize','off','Position',[450 300 600 500]);
Text0  = sprintf('BSD 2-Clause Licence \n\n');
Text1  = sprintf('Simulation for redox-active Film based Photoelectrodes');
Text2  = sprintf('\n Version: 1.02 \t[bug reports to thomas.hoefer@rub.de] \n\n');
Text3  = sprintf('This software can be used to simulate photoelectrodes based on redox-active films (mediated electron transfer). ');
Text4  = sprintf('Different models can be selected under "Choose appropriate Model" or "Menu -> Model (Ctrl + M)". ');
Text5  = sprintf('');
Text6  = sprintf('The simulation is only valid under various assumptions, please check the publication below (Open access) ');
Text7  = sprintf('to find out if one of the models fit for your system. ');
Text8  = sprintf('This paper could serve as a general literature citation when the PECSim software is employed for ');
Text9  = sprintf('the simulation of redox-active film based biophotoelectrodes:\n\n');
Text10 = sprintf('Buesen, D.; Hoefer, T.; Zhang, H.; Plumere, N. A Kinetic Model for Redox-Active Film ');
Text11 = sprintf('Based Biophotoelectrodes. Faraday Discuss. 2019. https://doi.org/10.1039/C8FD00168E.\n\n\n');

Text12 = sprintf('Copyright %c   [2019]  [Thomas Hoefer, Darren Buesen]\nAll rights reserved\n\n',char(169));
Text13 = sprintf('The Software was written in and compiled with MATLAB R2019a %c 1984-2019 The Mathworks, Inc.\n\n',char(169));

Text14 = sprintf('Redistribution and use in source and binary forms, with or without ');
Text15 = sprintf('modification, are permitted provided that the following conditions are met:\n\n');
Text16 = sprintf('1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n\n');
Text17 = sprintf('2. Redistributions in binary form must reproduce the above copyright notice, ');
Text18 = sprintf('this list of conditions and the following disclaimer in the documentation ');
Text19 = sprintf('and/or other materials provided with the distribution.');
Text20 = sprintf('\n\n');
Text21 = sprintf('THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" ');
Text22 = sprintf('AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE ');
Text23 = sprintf('IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE ');
Text24 = sprintf('DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE ');
Text25 = sprintf('FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL ');
Text26 = sprintf('DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR ');
Text27 = sprintf('SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER ');
Text28 = sprintf('CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, ');
Text29 = sprintf('OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE ');
Text30 = sprintf('OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. IN ANY WAY ');
Text31 = sprintf('IT IS PROHIBITED TO REMOVE ANY COPYRIGHT, TRADEMARK, LOGO, PROPRIETARY RIGHTS, ');
Text32 = sprintf('DISCLAIMER OR WARNING NOTICE INCLUDED ON OR EMBEDDE IN ANY PART OF THE SOFTWARE.');
Text = sprintf('%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',...
        Text0, Text1, Text2, Text3, Text4, Text5, Text6, Text7, Text8, Text9, Text10, Text11, Text12,...
        Text13, Text14, Text15, Text16, Text17, Text18, Text19, Text20, Text21, Text22, Text23,...
        Text24, Text25, Text26, Text27, Text28, Text29, Text30, Text31, Text32);
    
Textposition = Aboutf.Position;
Textposition(1:2) = 0;
AboutText = uitextarea(Aboutf,'Position',Textposition,'Value',Text,'BackgroundColor','w',...
    'FontSize',12);

% Aboutf.Units = 'inches';
% Aboutf.Position = [8,5,8,6];