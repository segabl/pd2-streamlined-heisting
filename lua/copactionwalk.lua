-- Helper function to get the final path position
function CopActionWalk:get_destination_pos()
	return self._nav_point_pos(self._simplified_path and self._simplified_path[#self._simplified_path] or self._nav_path and self._nav_path[#self._nav_path])
end
