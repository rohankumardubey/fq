package mpeg

import (
	"github.com/wader/fq/format"
	"github.com/wader/fq/format/registry"
	"github.com/wader/fq/pkg/decode"
)

var hevcAUNALFormat decode.Group

func init() {
	registry.MustRegister(decode.Format{
		Name:        format.HEVC_AU,
		Description: "H.265/HEVC Access Unit",
		DecodeFn:    hevcAUDecode,
		RootArray:   true,
		RootName:    "access_unit",
		Dependencies: []decode.Dependency{
			{Names: []string{format.HEVC_NALU}, Group: &hevcAUNALFormat},
		},
	})
}

func hevcAUDecode(d *decode.D, in interface{}) interface{} {
	hevcIn, ok := in.(format.HevcIn)
	if !ok {
		d.Errorf("hevcIn required")
	}

	for d.NotEnd() {
		d.FieldStruct("nalu", func(d *decode.D) {
			l := d.FieldU("length", int(hevcIn.LengthSize)*8)
			d.FieldFormatLen("nalu", int64(l)*8, hevcAUNALFormat, nil)
		})
	}

	return nil
}
