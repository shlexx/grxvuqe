local awaitRef = {}
local objects = {}
local coroutines = {}

local item = {
	id = 0;
	type = "ScreenGui";
	children = {
		[1] = {
			id = 1;
			type = "ScrollingFrame";
			children = {
				[1] = {
					id = 2;
					type = "UIListLayout";
					children = {};
					properties = {
						Parent = {
							[1] = 1;
						};
						SortOrder = Enum.SortOrder.LayoutOrder;
					};
				};
				[2] = {
					id = 3;
					type = "TextLabel";
					children = {
						[1] = {
							id = 4;
							type = "TextBox";
							children = {};
							properties = {
                                Text = "";
								CursorPosition = -1;
								TextColor3 = Color3.new(1, 1, 1);
								BorderColor3 = Color3.new(0, 0, 0);
								Parent = {
									[1] = 3;
								};
								TextSize = 14;
								PlaceholderText = "ID";
								PlaceholderColor3 = Color3.new(0.698039, 0.698039, 0.698039);
								FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								Position = UDim2.new(0.600000024, 0, 0.125, 0);
								Size = UDim2.new(0, 80, 0, 30);
								ClearTextOnFocus = false;
								BorderSizePixel = 0;
								BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078);
							};
						};
					};
					properties = {
						FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						TextColor3 = Color3.new(1, 1, 1);
						BorderColor3 = Color3.new(0, 0, 0);
						Text = "    Play ID";
						Parent = {
							[1] = 1;
						};
						TextWrapped = true;
						Name = "PlayId";
						TextXAlignment = Enum.TextXAlignment.Left;
						TextSize = 14;
						Size = UDim2.new(0, 250, 0, 40);
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.new(0.392157, 0.392157, 0.392157);
					};
				};
				[3] = {
					id = 5;
					type = "LocalScript";
					children = {};
					properties = {
						Parent = {
							[1] = 1;
						};
						Source = function()
							local script = objects[5]
						
							for i,v in pairs(script.Parent.Parent.Audios:GetChildren()) do
								task.spawn(function()
									local activated = false
									local Sound = Instance.new("TextLabel")
									local Play = Instance.new("ImageButton")
									Sound.Name = "Sound"
									Sound.Parent = script.Parent
									Sound.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
									Sound.BorderColor3 = Color3.fromRGB(0, 0, 0)
									Sound.BorderSizePixel = 0
									Sound.Size = UDim2.new(0, 250, 0, 40)
									Sound.Font = Enum.Font.FredokaOne
									Sound.Text = "    " .. v.Name
									Sound.TextColor3 = Color3.fromRGB(255, 255, 255)
									Sound.TextSize = 14.000
									Sound.TextWrapped = true
									Sound.TextXAlignment = Enum.TextXAlignment.Left
									Play.Name = "Play"
									Play.Parent = Sound
									Play.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
									Play.BorderColor3 = Color3.fromRGB(0, 0, 0)
									Play.BorderSizePixel = 0
									Play.Position = UDim2.new(0.800000012, 0, 0.125, 0)
									Play.Size = UDim2.new(0, 30, 0, 30)
									Play.Image = "rbxassetid://10734923549"
									Play.MouseButton1Click:Connect(function()
										if activated then
											activated = false
											Play.Image = "rbxassetid://10734923549"
											v:Stop()
										else
											activated = true
											Play.Image = "rbxassetid://10734919336"
											v:Play()
										end
									end)
								end)
							end
							
							game:GetService("UserInputService").InputBegan:Connect(function(input,e)
								if input.KeyCode == Enum.KeyCode.Equals and not e then
									script.Parent.Visible = not script.Parent.Visible
								end
							end)

                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Loaded",
                                Text = "Press = to open audio menu"
                            })
						end;
						Name = "MainScript";
					};
				};
			};
			properties = {
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
				Visible = false;
				Active = true;
				BorderColor3 = Color3.new(0, 0, 0);
				Parent = {
					[1] = 0;
				};
				ScrollBarImageColor3 = Color3.new(0, 0, 0);
				BackgroundTransparency = 0.5;
				Position = UDim2.new(0.407680959, 0, 0.342964828, 0);
				Size = UDim2.new(0, 250, 0, 250);
				Name = "Main";
				BorderSizePixel = 0;
				BackgroundColor3 = Color3.new(0, 0, 0);
			};
		};
		[2] = {
			id = 6;
			type = "Folder";
			children = {
				[1] = {
					id = 7;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1848354536";
						Name = "Relaxed Scene";
						Parent = {
							[1] = 6;
						};
					};
				};
				[2] = {
					id = 8;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1841647093";
						Name = "Life in an Elevator";
						Parent = {
							[1] = 6;
						};
					};
				};
				[3] = {
					id = 9;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1837879082";
						Name = "Paradise Falls";
						Parent = {
							[1] = 6;
						};
					};
				};
				[4] = {
					id = 10;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1837768517";
						Name = "Bossa Me (a)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[5] = {
					id = 11;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1840684529";
						Name = "Cool Vibes";
						Parent = {
							[1] = 6;
						};
					};
				};
				[6] = {
					id = 12;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1838457617";
						Name = "Clair De Lune";
						Parent = {
							[1] = 6;
						};
					};
				};
				[7] = {
					id = 13;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1845149698";
						Name = "Seek & Destroy";
						Parent = {
							[1] = 6;
						};
					};
				};
				[8] = {
					id = 14;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1846458016";
						Name = "No More";
						Parent = {
							[1] = 6;
						};
					};
				};
				[9] = {
					id = 15;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://142376088";
						Name = "Parry Gripp - Raining Tacos";
						Parent = {
							[1] = 6;
						};
					};
				};
				[10] = {
					id = 16;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1846575559";
						Name = "Diamonds";
						Parent = {
							[1] = 6;
						};
					};
				};
				[11] = {
					id = 17;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9045766377";
						Name = "Gymnopedie No. 1";
						Parent = {
							[1] = 6;
						};
					};
				};
				[12] = {
					id = 18;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://5409360995";
						Name = "Dion Timmer - Shiawase";
						Parent = {
							[1] = 6;
						};
					};
				};
				[13] = {
					id = 19;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9043887091";
						Name = "Lo-fi Chill A";
						Parent = {
							[1] = 6;
						};
					};
				};
				[14] = {
					id = 20;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1839857296";
						Name = "Convenience Store";
						Parent = {
							[1] = 6;
						};
					};
				};
				[15] = {
					id = 21;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9048375035";
						Name = "All Dropping 8 Bit Beats";
						Parent = {
							[1] = 6;
						};
					};
				};
				[16] = {
					id = 22;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9046862941";
						Name = "Sunset Chill (Bed Version)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[17] = {
					id = 23;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://118939739460633";
						Name = "Candyland";
						Parent = {
							[1] = 6;
						};
					};
				};
				[18] = {
					id = 24;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://86213259567076";
						Name = "Pixel Dog";
						Parent = {
							[1] = 6;
						};
					};
				};
				[19] = {
					id = 25;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://125793633964645";
						Name = "UNDERTALE: Spider Dance";
						Parent = {
							[1] = 6;
						};
					};
				};
				[20] = {
					id = 26;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://121336636707861";
						Name = "Sunburst";
						Parent = {
							[1] = 6;
						};
					};
				};
				[21] = {
					id = 27;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://83471372738525";
						Name = "It's Been So Long";
						Parent = {
							[1] = 6;
						};
					};
				};
				[22] = {
					id = 28;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://79451196298919";
						Name = "Infectious";
						Parent = {
							[1] = 6;
						};
					};
				};
				[23] = {
					id = 29;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://110733765539890";
						Name = "Five Nights at Freddy's";
						Parent = {
							[1] = 6;
						};
					};
				};
				[24] = {
					id = 30;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://99445078556609";
						Name = "Hope";
						Parent = {
							[1] = 6;
						};
					};
				};
				[25] = {
					id = 31;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://130283335515680";
						Name = "LoonBoom";
						Parent = {
							[1] = 6;
						};
					};
				};
				[26] = {
					id = 32;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://90438440882390";
						Name = "Main Menu";
						Parent = {
							[1] = 6;
						};
					};
				};
				[27] = {
					id = 33;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://90276503858375";
						Name = "Green Hills Zone";
						Parent = {
							[1] = 6;
						};
					};
				};
				[28] = {
					id = 34;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://111281710445018";
						Name = "PALMTREE PANIC FUNK (SLOWED)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[29] = {
					id = 35;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://139488665764275";
						Name = "Gothic";
						Parent = {
							[1] = 6;
						};
					};
				};
				[30] = {
					id = 36;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://115923681097964";
						Name = "Freaky Song (Incredibox Sprunki)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[31] = {
					id = 37;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://120889371113999";
						Name = "pac man phonk";
						Parent = {
							[1] = 6;
						};
					};
				};
				[32] = {
					id = 38;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://121853823597214";
						Name = "Gravity Falls";
						Parent = {
							[1] = 6;
						};
					};
				};
				[33] = {
					id = 39;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://97872482274072";
						Name = "I Got No Time";
						Parent = {
							[1] = 6;
						};
					};
				};
				[34] = {
					id = 40;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://104483584177040";
						Name = "spinning cat (o i i a)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[35] = {
					id = 41;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://124249063943651";
						Name = "Die in a Fire";
						Parent = {
							[1] = 6;
						};
					};
				};
				[36] = {
					id = 42;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://131874270028720";
						Name = "Isekai (Breakcore)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[37] = {
					id = 43;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://103999910201919";
						Name = "Eat";
						Parent = {
							[1] = 6;
						};
					};
				};
				[38] = {
					id = 44;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://84667154432130";
						Name = "desert jazz (prelude)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[39] = {
					id = 45;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://118026508123879";
						Name = "Here I Come";
						Parent = {
							[1] = 6;
						};
					};
				};
				[40] = {
					id = 46;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://131533591074605";
						Name = "Meatball Parade";
						Parent = {
							[1] = 6;
						};
					};
				};
				[41] = {
					id = 47;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://77468849088335";
						Name = "Fallen Down";
						Parent = {
							[1] = 6;
						};
					};
				};
				[42] = {
					id = 48;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://83119255728702";
						Name = "Новый Год";
						Parent = {
							[1] = 6;
						};
					};
				};
				[43] = {
					id = 49;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://94901108054210";
						Name = "Shop";
						Parent = {
							[1] = 6;
						};
					};
				};
				[44] = {
					id = 50;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://100001805913571";
						Name = "Lofi Jazz Hip Hop Abstract Chill Beat";
						Parent = {
							[1] = 6;
						};
					};
				};
				[45] = {
					id = 51;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://140453188008487";
						Name = "FUMAÇA PHONK (Smoke Remix - Brazilian Phonk Edit)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[46] = {
					id = 52;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://121990775364029";
						Name = "RIP CARTI #MIX";
						Parent = {
							[1] = 6;
						};
					};
				};
				[47] = {
					id = 53;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://78695734134326";
						Name = "먼저 신뢰하고";
						Parent = {
							[1] = 6;
						};
					};
				};
				[48] = {
					id = 54;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://107422347561984";
						Name = "Wii - Mii Channel";
						Parent = {
							[1] = 6;
						};
					};
				};
				[49] = {
					id = 55;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://120817494107898";
						Name = "Backrooms";
						Parent = {
							[1] = 6;
						};
					};
				};
				[50] = {
					id = 56;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://70417993466541";
						Name = "Brazilian Phonk Fiesta";
						Parent = {
							[1] = 6;
						};
					};
				};
				[51] = {
					id = 57;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://117078245462776";
						Name = "Cosmic Chill Music to Ease the Mind";
						Parent = {
							[1] = 6;
						};
					};
				};
				[52] = {
					id = 58;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://119089530564934";
						Name = "Faded memories";
						Parent = {
							[1] = 6;
						};
					};
				};
				[53] = {
					id = 59;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://101584470131484";
						Name = "Sukuna";
						Parent = {
							[1] = 6;
						};
					};
				};
				[54] = {
					id = 60;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://107666947795395";
						Name = "Red Sun In The Sky (Nightcore)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[55] = {
					id = 61;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://129069266097289";
						Name = "Chasing 8-Bit Coins";
						Parent = {
							[1] = 6;
						};
					};
				};
				[56] = {
					id = 62;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://139754643138137";
						Name = "Cuz I'm Hatsune Miku!";
						Parent = {
							[1] = 6;
						};
					};
				};
				[57] = {
					id = 63;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9047105533";
						Name = "No Smoking";
						Parent = {
							[1] = 6;
						};
					};
				};
				[58] = {
					id = 64;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1848028342";
						Name = "Nocturne Opus 9 C";
						Parent = {
							[1] = 6;
						};
					};
				};
				[59] = {
					id = 65;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://5410086218";
						Name = "Noisestorm - Crab Rave";
						Parent = {
							[1] = 6;
						};
					};
				};
				[60] = {
					id = 66;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://7029024726";
						Name = "Throttle - Bloom";
						Parent = {
							[1] = 6;
						};
					};
				};
				[61] = {
					id = 67;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://7024233823";
						Name = "Nitro Fun feat. Danyka Nadeau - Safe & Sound";
						Parent = {
							[1] = 6;
						};
					};
				};
				[62] = {
					id = 68;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://7029051434";
						Name = "Vindata - Good 4 Me";
						Parent = {
							[1] = 6;
						};
					};
				};
				[63] = {
					id = 69;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://16190757458";
						Name = "Bullet - Skibidi fanum tax (Prod. yakside)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[64] = {
					id = 70;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://1842241530";
						Name = "Lazy Sunday";
						Parent = {
							[1] = 6;
						};
					};
				};
				[65] = {
					id = 71;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9245561450";
						Name = "Parry Gripp - Chicken Nugget Dreamland";
						Parent = {
							[1] = 6;
						};
					};
				};
				[66] = {
					id = 72;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://9245552700";
						Name = "Parry Gripp - TacoBot 3000";
						Parent = {
							[1] = 6;
						};
					};
				};
				[67] = {
					id = 73;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://85105844586803";
						Name = "SQUID GAME FUNK (SLOWED) [ELECTRONIC FUNK]";
						Parent = {
							[1] = 6;
						};
					};
				};
				[68] = {
					id = 74;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://87660896074575";
						Name = "CELERITAS (SLIDE FUNK)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[69] = {
					id = 75;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://90290903837145";
						Name = "RESURRECTIO (SLOWED) [ELECTRONIC FUNK]";
						Parent = {
							[1] = 6;
						};
					};
				};
				[70] = {
					id = 76;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://70870883948497";
						Name = "VEM VEM CHILL FUNK (Sped Up)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[71] = {
					id = 77;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://96081093989136";
						Name = "APATHY FUNK (Slowed + Reverb)";
						Parent = {
							[1] = 6;
						};
					};
				};
				[72] = {
					id = 78;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://87632432872684";
						Name = "WALK (FUNK) SPED UP";
						Parent = {
							[1] = 6;
						};
					};
				};
				[73] = {
					id = 79;
					type = "Sound";
					children = {};
					properties = {
						SoundId = "rbxassetid://132691729125886";
						Name = "FUNK DE JONKLER";
						Parent = {
							[1] = 6;
						};
					};
				};
			};
			properties = {
				Name = "Audios";
				Parent = {
					[1] = 0;
				};
			};
		};
	};
	properties = {
		Parent = game["CoreGui"];
		Name = "AudioLibrary";
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	};
}
scan = function(objectData)
	local object = Instance.new(objectData.type)
	
	objects[objectData.id] = object
	
	for property, value in pairs(objectData.properties) do
		if type(value) == "table" then
			awaitRef[object] = {
				["v"] = value[1],
				["k"] = property
			}
			
			continue
		end
		
		if property == "Source" then
			table.insert(coroutines, coroutine.create(value))
			
			continue
		end
		
		object[property] = value
	end
	
	for _, child in pairs(objectData.children) do
		scan(child)
	end
end

scan(item) 

for object, data in pairs(awaitRef) do
	object[data.k] = objects[data.v]
end

for _, cCoroutine in pairs(coroutines) do
	coroutine.resume(cCoroutine)
end
