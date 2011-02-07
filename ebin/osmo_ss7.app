{application, osmo_ss7,
	[{description, "Osmocom SS7 code"},
	 {vsn, "1"},
	 {modules, [	osmo_util,
			ipa_proto, 
			bssmap_codec,
			isup_codec,
			m2ua_codec,
			mtp3_codec,
			sccp_codec, sccp_scoc,  sccp_scrc,
			sctp_handler
		]},
	 {registered, []},
	 {mod, {ipa_proto, []}},
	 {applications, []},
	 {env, [
	  ]}
]}.
