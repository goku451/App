import 'package:flutter/material.dart';

// ================================================================
// PANTALLA PARA CREAR PUBLICACIONES
// ================================================================

class CreatePostScreen extends StatefulWidget {
  final Institution institution;
  final Function(Post) onPostCreated;

  const CreatePostScreen({
    super.key,
    required this.institution,
    required this.onPostCreated,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Publicación"),
        backgroundColor: widget.institution.color,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createPost,
            child: Text(
              "Publicar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Institution info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.institution.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: widget.institution.color,
                      child: Icon(Icons.business, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Publicando en ${widget.institution.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: widget.institution.color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Título de la publicación",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Content field
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: "Contenido",
                    hintText: "¿Qué quieres compartir?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el contenido';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),

              // Media options
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildMediaOption(Icons.image, "Imagen", () {
                      // Handle image upload
                      _showImagePicker();
                    }),
                    SizedBox(width: 16),
                    _buildMediaOption(Icons.videocam, "Video", () {
                      // Handle video upload
                    }),
                    SizedBox(width: 16),
                    _buildMediaOption(Icons.attach_file, "Archivo", () {
                      // Handle file upload
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: widget.institution.color),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: widget.institution.color,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Tomar foto"),
              onTap: () {
                Navigator.pop(context);
                // Handle camera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Elegir de galería"),
              onTap: () {
                Navigator.pop(context);
                // Handle gallery
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 1), () {
        final newPost = Post(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          content: _contentController.text,
          author: "Tú", // In real app, get from user session
          date: DateTime.now(),
          likes: 0,
          comments: 0,
          imageUrl: null,
        );

        widget.onPostCreated(newPost);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Publicación creada exitosamente!"),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }
}

// ================================================================
// PANTALLA PARA CREAR EVENTOS
// ================================================================

class CreateEventScreen extends StatefulWidget {
  final Institution institution;
  final Function(Event) onEventCreated;

  const CreateEventScreen({
    super.key,
    required this.institution,
    required this.onEventCreated,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxAttendeesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Evento"),
        backgroundColor: widget.institution.color,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createEvent,
            child: Text(
              "Crear",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Institution info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.institution.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: widget.institution.color,
                      child: Icon(Icons.event, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Crear evento en ${widget.institution.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: widget.institution.color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Nombre del evento",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del evento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Date and time
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 12),
                            Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 12),
                            Text("${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Location field
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Ubicación",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Max attendees field
              TextFormField(
                controller: _maxAttendeesController,
                decoration: InputDecoration(
                  labelText: "Máximo de asistentes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número máximo de asistentes';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              // Create button
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.institution.color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Crear Evento"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 1), () {
        final eventDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final newEvent = Event(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          date: eventDateTime,
          location: _locationController.text,
          attendees: 0,
          maxAttendees: int.parse(_maxAttendeesController.text),
        );

        widget.onEventCreated(newEvent);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Evento creado exitosamente!"),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }
}

// ================================================================
// PANTALLA PARA CREAR ANUNCIOS
// ================================================================

class CreateAnnouncementScreen extends StatefulWidget {
  final Institution institution;
  final Function(Announcement) onAnnouncementCreated;

  const CreateAnnouncementScreen({
    super.key,
    required this.institution,
    required this.onAnnouncementCreated,
  });

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  AnnouncementPriority _selectedPriority = AnnouncementPriority.medium;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Anuncio"),
        backgroundColor: widget.institution.color,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createAnnouncement,
            child: Text(
              "Publicar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Institution info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.institution.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: widget.institution.color,
                      child: Icon(Icons.campaign, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Anuncio para ${widget.institution.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: widget.institution.color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Priority selector
              Text(
                "Prioridad del anuncio",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityChip(AnnouncementPriority.low, "Información", Colors.blue),
                  SizedBox(width: 8),
                  _buildPriorityChip(AnnouncementPriority.medium, "Importante", Colors.orange),
                  SizedBox(width: 8),
                  _buildPriorityChip(AnnouncementPriority.high, "Urgente", Colors.red),
                ],
              ),
              SizedBox(height: 20),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Título del anuncio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Content field
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: "Contenido del anuncio",
                  hintText: "Describe el anuncio de manera clara y concisa",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              // Create button
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createAnnouncement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.institution.color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Publicar Anuncio"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(AnnouncementPriority priority, String label, Color color) {
    final isSelected = _selectedPriority == priority;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _createAnnouncement() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 1), () {
        final newAnnouncement = Announcement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          content: _contentController.text,
          date: DateTime.now(),
          priority: _selectedPriority,
          author: "Administración", // In real app, get from user session
        );

        widget.onAnnouncementCreated(newAnnouncement);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Anuncio publicado exitosamente!"),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }
}

// ================================================================
// MODELOS DE DATOS (reutilizar si ya están definidos)
// ================================================================

class Post {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime date;
  int likes;
  int comments;
  final String? imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    required this.likes,
    required this.comments,
    this.imageUrl,
  });
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  int attendees;
  final int maxAttendees;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.attendees,
    required this.maxAttendees,
  });
}

class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final AnnouncementPriority priority;
  final String author;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.author,
  });
}

enum AnnouncementPriority { high, medium, low }

class Institution {
  final String id;
  final String name;
  final String description;
  final String? backgroundImage;
  final String? logoImage;
  final Color color;
  final int memberCount;
  final int postCount;
  final int eventCount;

  Institution({
    required this.id,
    required this.name,
    required this.description,
    this.backgroundImage,
    this.logoImage,
    required this.color,
    required this.memberCount,
    required this.postCount,
    required this.eventCount,
  });
}