#include "pebble_os.h"

uint32_t dict_calc_buffer_size(const uint8_t tuple_count, ...);

DictionaryResult dict_write_begin(DictionaryIterator *iter,
                                  uint8_t * const buffer, const uint16_t size);

DictionaryResult dict_write_data(DictionaryIterator *iter, const uint32_t key, const uint8_t * const data, const uint16_t size);
DictionaryResult dict_write_cstring(DictionaryIterator *iter, const uint32_t key, const char * const cstring);
DictionaryResult dict_write_int(DictionaryIterator *iter, const uint32_t key, const void *integer, const uint8_t width_bytes, const bool is_signed);
DictionaryResult dict_write_uint8(DictionaryIterator *iter, const uint32_t key, const uint8_t value);
DictionaryResult dict_write_uint16(DictionaryIterator *iter, const uint32_t key, const uint16_t value);
DictionaryResult dict_write_uint32(DictionaryIterator *iter, const uint32_t key, const uint32_t value);
DictionaryResult dict_write_int8(DictionaryIterator *iter, const uint32_t key, const int8_t value);
DictionaryResult dict_write_int16(DictionaryIterator *iter, const uint32_t key, const int16_t value);
DictionaryResult dict_write_int32(DictionaryIterator *iter, const uint32_t key, const int32_t value);
Tuple *dict_read_begin_from_buffer(DictionaryIterator *iter, const uint8_t * const buffer, const uint16_t size);
DictionaryResult dict_serialize_tuplets(DictionarySerializeCallback callback, void *context, const uint8_t tuplets_count, const Tuplet * const tuplets);
DictionaryResult dict_serialize_tuplets_to_buffer(const uint8_t tuplets_count, const Tuplet * const tuplets, uint8_t *buffer, uint32_t *size_in_out);
DictionaryResult dict_serialize_tuplets_to_buffer_with_iter(const uint8_t tuplets_count, const Tuplet * const tuplets, DictionaryIterator *iter, uint8_t *buffer, uint32_t *size_in_out);

Tuple *dict_read_next(DictionaryIterator *iter) {
  iter->cursor = iter->cursor + iter->cursor->length;
  if(iter->cursor == iter->end) {
    return NULL;
  }
  return iter->cursor;
}

Tuple *dict_read_first(DictionaryIterator *iter){
  iter->cursor = iter->dictionary->head;
  return iter->cursor;
}


DictionaryResult dict_write_tuplet(DictionaryIterator *iter,
                                   const Tuplet * const tuplet) {
  Tuple *t = iter->dictionary->head;
  int counter = iter->dictionary->count - 1;
  iter->dictionary->count++;
  
  // TODO: Check whether there's actually enough space

  // traverse to the end of the data in the dictionary
  while (counter > 0) {
    t = t+t->length;
    counter--;
  }

  t->key = tuplet->key;
  t->type = tuplet->type;

  // and store our new tuple there
  switch(tuplet->type) {
  case TUPLE_BYTE_ARRAY:
    t->length = tuplet->bytes.length;
    memcpy(t->value->data, tuplet->bytes.data, sizeof(&tuplet->bytes.data));
    break;
  case TUPLE_CSTRING:
    t->length = tuplet->cstring.length;
    memcpy(t->value->cstring, tuplet->cstring.data, sizeof(&tuplet->cstring.data));
    break;
  case TUPLE_UINT:
    t->length = tuplet->integer.width;
    switch(t->length) {
    case 8:
      t->value->uint8 = (uint8_t)tuplet->integer.storage;
      break;
    case 16:
      t->value->uint16 = (uint16_t)tuplet->integer.storage;
      break;
    case 32:
      t->value->uint32 = (uint32_t)tuplet->integer.storage;
      break;
    }
    break;
  case TUPLE_INT:
    switch(t->length) {
    case 8:
      t->value->int8 = (int8_t)tuplet->integer.storage;
      break;
    case 16:
      t->value->int16 = (int16_t)tuplet->integer.storage;
      break;
    case 32:
      t->value->int32 = (int32_t)tuplet->integer.storage;
      break;
    }
    break;
  }

  return DICT_OK;
};

Tuple *dict_find(const DictionaryIterator *iter, const uint32_t key) {
  Tuple *t = iter->dictionary->head;
  int counter = iter->dictionary->count;
  
  while (counter > 0) {
    if (t->key == key) {
      return t;
    }
    t = t+t->length;
    counter--;
  }
  
  return NULL;
}

uint32_t dict_write_end(DictionaryIterator *iter) {
  Tuple *t = iter->dictionary->head;
  int counter = iter->dictionary->count;
  uint32_t size = 0;
  
  while (counter > 0) {
    size += t->length;
    t = t+t->length;
    counter--;
  }

  iter->end = iter->dictionary->head + size;
  return size;
}


uint32_t dict_calc_buffer_size_from_tuplets(const uint8_t tuplets_count, const Tuplet * const tuplets);
DictionaryResult dict_merge(DictionaryIterator *dest, uint32_t *dest_max_size_in_out, DictionaryIterator *source, const bool update_existing_keys_only, const DictionaryKeyUpdatedCallback key_callback, void *context);
