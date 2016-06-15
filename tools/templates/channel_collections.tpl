# This file auto-generated by `generate_schema_interface.py`.
# Do not modify this file directly.

import traitlets as T
from .. import _interface as schema
from ..baseobject import BaseObject

{% for import_statement in objects|merge_imports -%}
  {{ import_statement }}
{% endfor %}

{% for cls in objects -%}
class {{ cls.name }}(schema.{{ cls.basename }}):
    """Object for storing channel encodings

    Attributes
    ----------
    {% for attr in cls.attributes -%}
    {{ attr.name }}: {{ attr.trait_descr }}
        {{ attr.short_description }}
    {% endfor -%}
    """
    {% for attr in cls.attributes -%}
    {{ attr.name }} = {{ attr.trait_fulldef }}
    {% endfor %}

    {%- set comma = joiner(", ") %}
    channel_names = [{% for attr in cls.attributes %}{{ comma() }}'{{ attr.name }}'{% endfor %}]
    parent = T.Instance(BaseObject, default_value=None, allow_none=True)

    skip = ['channel_names', 'parent']

    def _infer_types(self, data):
        for attr in self.channel_names:
            val = getattr(self, attr)
            if val is not None:
                val._infer_type(data)

    @T.observe(*channel_names)
    def _channel_changed(self, change):
        new = change['new']
        name = change['name']
        channel = getattr(self, name, None)
        if channel is not None and self.parent is not None and not getattr(channel, 'type', ''):
            meth = getattr(channel, '_infer_type', None)
            if meth is not None:
                meth(self.parent.data)


{% endfor -%}