import Foundation


var base = 0.25
var sizes: [any Sizes] = HalfSizes.allCases + RegularSizes.allCases
var url = URL(string: "file://" + FileManager.default.currentDirectoryPath)!


protocol Sizes: CaseIterable { 
	var factor: Double { get }
}

extension Sizes { 
	var id: String { "\(self)" }
	var f: String { 
		id.replacingOccurrences(of: "s", with: "")
	}
	
	var value: String { "\(base*factor)rem" }
}


enum HalfSizes: Double, Sizes {
	
	var factor: Double { self.rawValue }
	
	case sh = 0.5
	case s1h = 1.5
	case s2h = 2.5
	case s3h = 3.5
}

enum RegularSizes: Int, Sizes {
	
	var factor: Double { Double(self.rawValue) }
	
	case s1 = 1
	case s2
	case s3
	case s4 
	case s6
	case s7
	case s8
	case s9
	case s10
	case s11
	case s12
	case s13
	case s14
	case s16
	case s20
	case s24
	case s28
	case s32
	case s36
	case s40
	case s44
	case s48
	case s52
	case s56
	case s60
	case s64
	case s72
	case s80
	case s96
}


func sizes(prefix: String, prop: String) throws {
	let mapped = sizes.map { size in
		renderAsClasses(prefix: prefix, prop: prop, size: size)
	}.joined(separator: "\n")
	
	let filename = url.appendingPathComponent("\(prop).css")
	try mapped.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
}

func renderPaddingMargin(prefix: String, prop: String, size: any Sizes) -> String {
	"""
	*[\(prefix)=\(size.id)]{\(prop):\(size.value)}
	*[\(prefix)-left=\(size.id)]{\(prop)-left:\(size.value)}
	*[\(prefix)-right=\(size.id)]{\(prop)-right:\(size.value)}
	*[\(prefix)-top=\(size.id)]{\(prop)-top:\(size.value)}
	*[\(prefix)-bottom=\(size.id)]{\(prop)-bottom:\(size.value)}
	*[\(prefix)-horizontal=\(size.id)]{\(prop)-left: \(size.value); \(prop)-right: \(size.value)}
	*[\(prefix)-vertical=\(size.id)]{\(prop)-bottom: \(size.value); \(prop)-top: \(size.value)}
	"""
}

func renderAsClasses(prefix: String, prop: String, size: any Sizes) -> String {
	"""
	.\(prefix)\(size.f) {\(prop):\(size.value)}
	.\(prefix)l\(size.f) {\(prop)-left:\(size.value)}
	.\(prefix)r\(size.f) {\(prop)-right:\(size.value)}
	.\(prefix)t\(size.f) {\(prop)-top:\(size.value)}
	.\(prefix)b\(size.f) {\(prop)-bottom:\(size.value)}
	.\(prefix)h\(size.f) {\(prop)-left: \(size.value); \(prop)-right: \(size.value)}
	.\(prefix)v\(size.f) {\(prop)-bottom: \(size.value); \(prop)-top: \(size.value)}
	"""
}

func positioning() throws {
	let mapped = sizes.map { size in
		"""
		*[bottom=\(size.id)]{bottom:\(size.value)}
		*[top=\(size.id)]{top:\(size.value)}
		*[left=\(size.id)]{left:\(size.value)}
		*[right=\(size.id)]{left:\(size.value)}
		"""
	}.joined(separator: "\n")
	
	let filename = url.appendingPathComponent("positioning.css")
	try mapped.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
}


func make() {
	do {
		try sizes(prefix: "m", prop: "margin")
		try sizes(prefix: "p", prop: "padding")
		try positioning()
		
	} catch { 
		print(error.localizedDescription)
	}
}

//make()
print(url)
