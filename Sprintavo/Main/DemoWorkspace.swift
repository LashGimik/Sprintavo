import Foundation

enum DemoWorkspace {
    static var items: [WorkspaceItem] {
        let sprintavo = WorkspaceItem(section: .projects, title: "Sprintavo", subtitle: "Личное рабочее пространство", details: "Собрать первый полезный билд: проекты, задачи и локальное сохранение.")
        let portfolio = WorkspaceItem(section: .projects, title: "Портфолио", subtitle: "Подготовка к собеседованиям", details: "Собрать проекты, описать решения и подготовить демонстрацию.", projectColor: .coral)
        let learning = WorkspaceItem(section: .projects, title: "Изучение Swift", subtitle: "Практика каждый день", details: "Закрепить работу с моделями, состоянием и хранением данных.", projectColor: .blue)
        let archived = WorkspaceItem(section: .projects, title: "Первый прототип", subtitle: "Завершённый проект", details: "Первые эксперименты со SwiftUI. Сохранены для истории.", isArchived: true, projectColor: .gray)
        return [sprintavo, portfolio, learning, archived,
            WorkspaceItem(section: .sprints, title: "Первый рабочий билд", subtitle: "В работе · Sprintavo", details: "Цель: пройти путь от проекта до выполненной задачи.", projectID: sprintavo.id),
            WorkspaceItem(section: .sprints, title: "Подготовка портфолио", subtitle: "Запланирован · Портфолио", details: "Выбрать проекты и описать их назначение.", projectID: portfolio.id),
            WorkspaceItem(section: .sprints, title: "Неделя практики", subtitle: "Запланирован · Изучение Swift", details: "Разобрать состояние представлений и связи моделей.", projectID: learning.id),
            WorkspaceItem(section: .tasks, title: "Собрать домашний экран", subtitle: "В работе · Sprintavo", details: "Показать проекты, спринты и задачи. Добавить переходы между разделами.", projectID: sprintavo.id, taskStatus: .inProgress, dueDate: Date(), checklist: [
                TaskChecklistItem(title: "Определить основные блоки главного экрана", status: .completed),
                TaskChecklistItem(title: "Добавить заголовок и кнопку выбора разделов", status: .completed),
                TaskChecklistItem(title: "Сверстать горизонтальную ленту последних проектов", status: .inProgress),
                TaskChecklistItem(title: "Показать выбранный проект и его цветной значок"),
                TaskChecklistItem(title: "Настроить переход из карточки проекта в его обзор"),
                TaskChecklistItem(title: "Добавить список ближайших задач и компактные плашки статуса и срока", status: .inProgress),
                TaskChecklistItem(title: "Продумать пустое состояние для проекта, в котором пока нет задач"),
                TaskChecklistItem(title: "Подготовить блок текущего спринта", status: .postponed),
                TaskChecklistItem(title: "Проверить длинные названия проектов и переносы строк на маленьком экране"),
                TaskChecklistItem(title: "Проверить крупный размер текста и озвучивание кнопок VoiceOver"),
                TaskChecklistItem(title: "Настроить плавное открытие и закрытие меню", status: .completed),
                TaskChecklistItem(title: "Проверить возврат из деталей без потери позиции прокрутки")
            ]),
            WorkspaceItem(section: .tasks, title: "Добавить локальное хранение", subtitle: "К выполнению · Sprintavo", details: "Сохранять проекты и задачи между запусками приложения.", projectID: sprintavo.id),
            WorkspaceItem(section: .tasks, title: "Описать первый проект", subtitle: "К выполнению · Портфолио", details: "Рассказать о проблеме, решении и принятых технических решениях.", projectID: portfolio.id),
            WorkspaceItem(section: .notes, title: "Идея Sprintavo", subtitle: "Заметка · Sprintavo", details: "Проекты, задачи, заметки и спринты в одном локальном приложении.", projectID: sprintavo.id),
            WorkspaceItem(section: .notes, title: "Что рассказать на собеседовании", subtitle: "Заметка · Портфолио", details: "Почему выбрал MVVM, как устроены данные и какие компромиссы принял.", projectID: portfolio.id),
            WorkspaceItem(section: .notes, title: "Состояние в SwiftUI", subtitle: "Заметка · Изучение Swift", details: "Разобраться, кто владеет состоянием и какие представления его используют.", projectID: learning.id)
        ]
    }
}
