package;

import haxe.Json;
import hscript.Parser;
import openfl.display.Sprite;
import openfl.Assets;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import openfl.text.TextField;
import hscript.Interp;
import hscript.Expr.Error;
import hscript.Expr.ErrorDef;

class Generator
{

	private var _data:Dynamic;
	private var _scenes:Array<Sprite> = [];
	private var _fileContents:String;
	private var _fileName:String;
	private var _interp:Interp;
	private var _parser:Parser;
	
	public function new(file:String, interp:Interp, parse:Parser) 
	{
		_fileName = file;
		_fileContents = File.getContent(file);
		_data = Json.parse(_fileContents);
		_interp = interp;
		_parser = parse;
		
		if (_data.currentScene != "")
			generateScene(_data.currentScene);
	}
	
	public function generateScene(name:String):Void
	{
		var existsInScenes:Bool = false;
		var scene:Sprite = null;
		var index:Int = 0;
		for (item in _scenes)
		{
			if (item.name == name)
			{
				existsInScenes = true;
				scene = item;
				index = _scenes.indexOf(item);
				break;
			}
		}
		
		for (i in 0..._data.scenes.length)
		{
			if (_data.scenes[i].name == name)
			{
				
				//If scene has already been generated
				if (scene != null)
				{
					//Check each layer in scene
					for (j in 0..._data.scenes[i].layers.length)
					{
						var layer = _data.scenes[i].layers[j];
						for (h in 0...layer.members.length)
						{
							var member = layer.members[h];
							for (k in 0...scene.numChildren)
								scene.removeChildAt(k);
							
							if (checkParse(member, member.script))
								continue;
							else
								break;
						}
					}
				}
				//If scene has not been generated
				else
				{
					for (j in 0..._data.scenes[i].layers.length)
					{
						
					}
				}
			}
		}
	}
	
	private function checkParse(obj:Dynamic, code:String):Bool
	{
		try
		{
			var result = _parser.parseString(code);
			var exec = _interp.execute(result);
			return true;
		}
		catch (e:Error)
		{
			
			trace("Error: Line(" + _parser.line + "): " + e.pmin + " - " + e.pmax + ": " + obj.name);
			
			return false;
		}
	}
	
	public function refresh():Void
	{
		_fileContents = File.getContent(_fileName);
		_data = Json.parse(_fileContents);
	}
	
	public function getScenes():Array<Sprite>
	{
		return _scenes;
	}
	
}