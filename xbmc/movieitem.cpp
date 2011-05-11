/*****************************************************************************
 * Copyright: 2011 Michael Zanetti <mzanetti@kde.org>                        *
 *                                                                           *
 * This program is free software: you can redistribute it and/or modify      *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, either version 3 of the License, or         *
 * (at your option) any later version.                                       *
 *                                                                           *
 * This program is distributed in the hope that it will be useful,           *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU General Public License for more details.                              *
 *                                                                           *
 * You should have received a copy of the GNU General Public License         *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                           *
 ****************************************************************************/

#include "movieitem.h"

MovieItem::MovieItem(const QString &label, int id):
    m_label(label),
    m_id(id)
{
}

void MovieItem::setLabel(const QString &label)
{
    m_label = label;
}

void MovieItem::setId(int id)
{
    m_id = id;
}

QString MovieItem::label() const
{
    return m_label;
}

int MovieItem::id() const
{
    return m_id;
}