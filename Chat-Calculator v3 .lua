script_author('Adrian G.')
script_name('���-�����������')
----------------------------------------------------------------------------------------------------------------
local imgui = require 'imgui'
local window = imgui.ImBool(false)
local window2 = imgui.ImBool(false)
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
imgui.ShowCursor = false

function main()
    repeat wait(100) until isSampAvailable()
    while true do wait(0)
        text = sampGetChatInputText()
    
        if text:find('%d+') and text:find('[-+/*^%%]') and not text:find('%a+') and text ~= nil then
            ok, number = pcall(load('return '..text))
            result = '���������: '..number
        end

        if text:find('%d+%%%*%d+') then
            number1, number2 = text:match('(%d+)%%%*(%d+)')
            number = number1*number2/100
            ok, number = pcall(load('return '..number))
            result = '���������: '..number
        end

        if text:find('%d+%%%/%d+') then
            number1, number2 = text:match('(%d+)%%%/(%d+)')
            number = number2/number1*100
            ok, number = pcall(load('return '..number))
            result = '���������: '..number
        end

        if text:find('%d+/%d+%%') then
            number1, number2 = text:match('(%d+)/(%d+)%%')
            number = number1*100/number2
            ok, number = pcall(load('return '..number))
            number = ok and number..'%' or number
            result = '���������: '..number
        end


        
        if text == 'calc' then
            help = true
        else
            help = false
        end


        if text == '' then
            ok = false
        end

        imgui.Process = ok or help
    end
end

function imgui.OnDrawFrame()
    local input = sampGetInputInfoPtr()
    local input = getStructElement(input, 0x8, 4)
    local windowPosX = getStructElement(input, 0x8, 4)
    local windowPosY = getStructElement(input, 0xC, 4)
    
    if sampIsChatInputActive() and ok then
        imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 30 + 15), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(result:len()*10, 30))
        imgui.Begin('Solve', window, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
        imgui.CenterText(u8(number_separator(result)))
        if imgui.IsWindowHovered() and imgui.IsMouseClicked(0) then
            setClipboardText(number)
         end
        imgui.End()
    end
        if sampIsChatInputActive() and help then
            imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 30 + 15), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowSize(imgui.ImVec2(800, 130))
            imgui.Begin('Help', window2, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
            imgui.Text(u8[[23%/100 - ����� ����� ������ �� ��������. 23 - ��� �������, 100 ��� ������� ���������� ���� ������� �� ������������ �����.
23 �������� ������ ����� 100, � 100 ��������� ����� 434.
-
23%*100 - ����� �����, ������� ���������� ���������� ���������. 23 - ��� ���������� ���������, 
100 - ����� �� �������� ����� ����� �������. 23 �������� �� ����� 100 - ��� 23.
-
23/100% - ����� ���������� ����������� ���� �����. 23 - ��� �����, ���������� ����������� �� ����� 100.
����� 23 ���������� 23 �������� �� ����� 100.]])
            imgui.End()
        end
    
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function number_separator(n) 
	local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end
