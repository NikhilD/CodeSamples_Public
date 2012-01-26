"""autogenerated by genmsg_py from dirantenna_communicationFeedback.msg. Do not edit."""
import roslib.message
import struct


class dirantenna_communicationFeedback(roslib.message.Message):
  _md5sum = "6351628d0196679f44e2308d5c767ac0"
  _type = "dirantenna_communication_actionserver/dirantenna_communicationFeedback"
  _has_header = False #flag to mark the presence of a Header object
  _full_text = """# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
#feedback definition
string[] strId_Mote
uint16[] rssCount_Mote
float64[] rssVals


"""
  __slots__ = ['strId_Mote','rssCount_Mote','rssVals']
  _slot_types = ['string[]','uint16[]','float64[]']

  def __init__(self, *args, **kwds):
    """
    Constructor. Any message fields that are implicitly/explicitly
    set to None will be assigned a default value. The recommend
    use is keyword arguments as this is more robust to future message
    changes.  You cannot mix in-order arguments and keyword arguments.
    
    The available fields are:
       strId_Mote,rssCount_Mote,rssVals
    
    @param args: complete set of field values, in .msg order
    @param kwds: use keyword arguments corresponding to message field names
    to set specific fields. 
    """
    if args or kwds:
      super(dirantenna_communicationFeedback, self).__init__(*args, **kwds)
      #message fields cannot be None, assign default values for those that are
      if self.strId_Mote is None:
        self.strId_Mote = []
      if self.rssCount_Mote is None:
        self.rssCount_Mote = []
      if self.rssVals is None:
        self.rssVals = []
    else:
      self.strId_Mote = []
      self.rssCount_Mote = []
      self.rssVals = []

  def _get_types(self):
    """
    internal API method
    """
    return self._slot_types

  def serialize(self, buff):
    """
    serialize message into buffer
    @param buff: buffer
    @type  buff: StringIO
    """
    try:
      length = len(self.strId_Mote)
      buff.write(_struct_I.pack(length))
      for val1 in self.strId_Mote:
        length = len(val1)
        buff.write(struct.pack('<I%ss'%length, length, val1))
      length = len(self.rssCount_Mote)
      buff.write(_struct_I.pack(length))
      pattern = '<%sH'%length
      buff.write(struct.pack(pattern, *self.rssCount_Mote))
      length = len(self.rssVals)
      buff.write(_struct_I.pack(length))
      pattern = '<%sd'%length
      buff.write(struct.pack(pattern, *self.rssVals))
    except struct.error as se: self._check_types(se)
    except TypeError as te: self._check_types(te)

  def deserialize(self, str):
    """
    unpack serialized message in str into this message instance
    @param str: byte array of serialized message
    @type  str: str
    """
    try:
      end = 0
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      self.strId_Mote = []
      for i in range(0, length):
        start = end
        end += 4
        (length,) = _struct_I.unpack(str[start:end])
        start = end
        end += length
        val1 = str[start:end]
        self.strId_Mote.append(val1)
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      pattern = '<%sH'%length
      start = end
      end += struct.calcsize(pattern)
      self.rssCount_Mote = struct.unpack(pattern, str[start:end])
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      pattern = '<%sd'%length
      start = end
      end += struct.calcsize(pattern)
      self.rssVals = struct.unpack(pattern, str[start:end])
      return self
    except struct.error as e:
      raise roslib.message.DeserializationError(e) #most likely buffer underfill


  def serialize_numpy(self, buff, numpy):
    """
    serialize message with numpy array types into buffer
    @param buff: buffer
    @type  buff: StringIO
    @param numpy: numpy python module
    @type  numpy module
    """
    try:
      length = len(self.strId_Mote)
      buff.write(_struct_I.pack(length))
      for val1 in self.strId_Mote:
        length = len(val1)
        buff.write(struct.pack('<I%ss'%length, length, val1))
      length = len(self.rssCount_Mote)
      buff.write(_struct_I.pack(length))
      pattern = '<%sH'%length
      buff.write(self.rssCount_Mote.tostring())
      length = len(self.rssVals)
      buff.write(_struct_I.pack(length))
      pattern = '<%sd'%length
      buff.write(self.rssVals.tostring())
    except struct.error as se: self._check_types(se)
    except TypeError as te: self._check_types(te)

  def deserialize_numpy(self, str, numpy):
    """
    unpack serialized message in str into this message instance using numpy for array types
    @param str: byte array of serialized message
    @type  str: str
    @param numpy: numpy python module
    @type  numpy: module
    """
    try:
      end = 0
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      self.strId_Mote = []
      for i in range(0, length):
        start = end
        end += 4
        (length,) = _struct_I.unpack(str[start:end])
        start = end
        end += length
        val1 = str[start:end]
        self.strId_Mote.append(val1)
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      pattern = '<%sH'%length
      start = end
      end += struct.calcsize(pattern)
      self.rssCount_Mote = numpy.frombuffer(str[start:end], dtype=numpy.uint16, count=length)
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      pattern = '<%sd'%length
      start = end
      end += struct.calcsize(pattern)
      self.rssVals = numpy.frombuffer(str[start:end], dtype=numpy.float64, count=length)
      return self
    except struct.error as e:
      raise roslib.message.DeserializationError(e) #most likely buffer underfill

_struct_I = roslib.message.struct_I