# $NetBSD: buildlink3.mk,v 1.30 2017/06/20 22:37:53 joerg Exp $

BUILDLINK_TREE+=	${PYPKGPREFIX}-game

.if !defined(PY_GAME_BUILDLINK3_MK)
PY_GAME_BUILDLINK3_MK:=

.include "../../lang/python/pyversion.mk"

BUILDLINK_API_DEPENDS.${PYPKGPREFIX}-game+=	${PYPKGPREFIX}-game>=1.9.1
BUILDLINK_ABI_DEPENDS.${PYPKGPREFIX}-game+=	${PYPKGPREFIX}-game>=1.9.1nb2
BUILDLINK_PKGSRCDIR.${PYPKGPREFIX}-game?=	../../devel/py-game

.include "../../audio/SDL_mixer/buildlink3.mk"
.include "../../devel/SDL/buildlink3.mk"
.include "../../devel/SDL_ttf/buildlink3.mk"
.include "../../graphics/SDL_image/buildlink3.mk"
.include "../../graphics/png/buildlink3.mk"
.include "../../multimedia/smpeg/buildlink3.mk"
.if ${OPSYS} != "Darwin"
.  include "../../x11/libX11/buildlink3.mk"
.endif
.endif # PY_GAME_BUILDLINK3_MK

BUILDLINK_TREE+=	-${PYPKGPREFIX}-game
