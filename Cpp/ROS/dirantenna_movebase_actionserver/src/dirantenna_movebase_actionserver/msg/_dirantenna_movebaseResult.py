"""autogenerated by genmsg_py from dirantenna_movebaseResult.msg. Do not edit."""
import roslib.message
import struct


class dirantenna_movebaseResult(roslib.message.Message):
  _md5sum = "377265f318a793f7dcf18ede45901561"
  _type = "dirantenna_movebase_actionserver/dirantenna_movebaseResult"
  _has_header = False #flag to mark the presence of a Header object
  _full_text = """# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
#result definition
bool success
float64 distance
float64 angle

"""
  __slots__ = ['success','distance','angle']
  _slot_types = ['bool','float64','float64']

  def __init__(self, *args, **kwds):
    """
    Constructor. Any message fields that are implicitly/explicitly
    set to None will be assigned a default value. The recommend
    use is keyword arguments as this is more robust to future message
    changes.  You cannot mix in-order arguments and keyword arguments.
    
    The available fields are:
       success,distance,angle
    
    @param args: complete set of field values, in .msg order
    @param kwds: use keyword arguments corresponding to message field names
    to set specific fields. 
    """
    if args or kwds:
      super(dirantenna_movebaseResult, self).__init__(*args, **kwds)
      #message fields cannot be None, assign default values for those that are
      if self.success is None:
        self.success = False
      if self.distance is None:
        self.distance = 0.
      if self.angle is None:
        self.angle = 0.
    else:
      self.success = False
      self.distance = 0.
      self.angle = 0.

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
      _x = self
      buff.write(_struct_B2d.pack(_x.success, _x.distance, _x.angle))
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
      _x = self
      start = end
      end += 17
      (_x.success, _x.distance, _x.angle,) = _struct_B2d.unpack(str[start:end])
      self.success = bool(self.success)
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
      _x = self
      buff.write(_struct_B2d.pack(_x.success, _x.distance, _x.angle))
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
      _x = self
      start = end
      end += 17
      (_x.success, _x.distance, _x.angle,) = _struct_B2d.unpack(str[start:end])
      self.success = bool(self.success)
      return self
    except struct.error as e:
      raise roslib.message.DeserializationError(e) #most likely buffer underfill

_struct_I = roslib.message.struct_I
_struct_B2d = struct.Struct("<B2d")
