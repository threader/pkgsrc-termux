# $NetBSD: buildlink3.mk,v 1.4 2015/07/20 11:30:54 wiz Exp $

BUILDLINK_TREE+=	lua52

.if !defined(LUA52_BUILDLINK3_MK)
LUA52_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.lua52+=	lua52>=5.2.0<5.3
BUILDLINK_PKGSRCDIR.lua52?=	../../lang/lua52

.if defined(BUILDLINK_DEPMETHOD.lua)
BUILDLINK_DEPMETHOD.lua52?=	${BUILDLINK_DEPMETHOD.lua}
.endif

# -llua -> -llua5.2
BUILDLINK_TRANSFORM+=		l:lua:lua5.2
BUILDLINK_INCDIRS.lua52+=	include/lua-5.2

.include "../../mk/readline.buildlink3.mk"
.endif # LUA52_BUILDLINK3_MK

BUILDLINK_TREE+=	-lua52
