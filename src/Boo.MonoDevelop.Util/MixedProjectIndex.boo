namespace Boo.MonoDevelop.Util

import System
import System.IO

import Boo.Ide
import MonoDevelop.Core
import MonoDevelop.Projects

class MixedProjectIndex(ProjectIndex):
	_booIndex as ProjectIndex
	_usIndex as ProjectIndex
	_project as DotNetProject

	def constructor(project as DotNetProject, booIndex as ProjectIndex, usIndex as ProjectIndex):
		_project = project
		_booIndex = booIndex
		_usIndex = usIndex
		
		for reference in _project.References:
			_booIndex.AddReference(reference.Reference)
			_usIndex.AddReference(reference.Reference)
			
	override def ProposalsFor(filename as string, code as string):
		return IndexForSourceFile(filename).ProposalsFor(filename, code)
		
	override def MethodsFor(filename as string, code as string, methodName as string, methodLine as int):
		return IndexForSourceFile(filename).MethodsFor(filename, code, methodName, methodLine)
		
	override def ImportsFor(filename as string, code as string):
		return IndexForSourceFile(filename).ImportsFor(filename, code)
		
	override def AddReference(reference as System.Reflection.Assembly):
		_usIndex.AddReference(reference)
		_booIndex.AddReference(reference)
				
	override def LocalsAt(filename as string, code as string, line as int):
		return IndexForSourceFile(filename).LocalsAt(filename, code, line)
		
	def IndexForSourceFile(filename as string):
		if filename.EndsWith(".js", StringComparison.OrdinalIgnoreCase): return _usIndex
		return _booIndex