-- Link: https://create.roblox.com/store/asset/96115290481724/CameraCFrameViewer
local Toolbar: PluginToolbar = plugin:CreateToolbar("Lincoln's Camera Tools");
local CoreGui: CoreGui = game:GetService("CoreGui"); 	

local w = coroutine.wrap;
local ToFixed = function(n: number, places: number): string
	if math.round(n) == n then return tostring(n); end; 		
	local r = tostring(n):split('.'); 			
	return r[1] ..'.'.. r[2]:sub(1, places); 		
end; 		 	
local IsOpen = function(interfaceId: string?): boolean
	local ExistsUnderCoreGui: (Instance | nil)? = CoreGui:FindFirstChild(`LCT_PLUGIN_{interfaceId:upper()}`);
	if ExistsUnderCoreGui then
		return true, ExistsUnderCoreGui;	 		
	else return false, nil; end;
end; 		
local ToggleInterface = function(id: string?): boolean
	local ExistsUnderCoreGui: boolean, ExistingInterface: (ScreenGui | nil)? = IsOpen(id); 	
	if ExistsUnderCoreGui then
		ExistingInterface:Destroy(); 	
		return false, ExistingInterface;
	else		 	
		local Interface: ScreenGui? = script:WaitForChild(id):Clone(); 	
		Interface.Name = `LCT_PLUGIN_{id:upper()}`; 	
		Interface.Parent = CoreGui; 		
		return true, Interface;
	end; 	
end;	 
local Camera = function(): Camera? return workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera'); end; 
local Buttons = {
	{ 			 	             
		Title = 'Copy CFrame',
		Desc = 'Copies the current CFrame of the Camera.', 	
		Click = function(): () 	
			local id = 'CameraPlugin'; 		
			local opened: boolean, reference: ScreenGui? = ToggleInterface(id); 			
			if opened then
				w(function(): ()
					while IsOpen(id) do
						local t = function(n): string return ToFixed(n, 2); end;
						local c: CFrame = Camera().CFrame;	 
						local a: Vector3, b: Vector3 = 
							c.Position, c.Position + c.LookVector;
						local s: string = `CFrame.new(Vector3.new({t(a.X)}, {t(a.Y)}, {t(a.Z)}), Vector3.new({t(b.X)}, {t(b.Y)}, {t(b.Z) }))`; 	
						reference.Copy.Text = s;
						task.wait(); 			
					end;
				end)(); 		
			end;
		end,
	}
};

for _, Data in Buttons do
	local v1 = Toolbar:CreateButton(Data.Title, Data.Desc or "", Data.Icon or "");	 	
	v1.Click:Connect(Data.Click); 	
end;
