extends AudioStreamPlayer

func play_sound(stream: AudioStream):
	self.stream = stream
	self.play()
