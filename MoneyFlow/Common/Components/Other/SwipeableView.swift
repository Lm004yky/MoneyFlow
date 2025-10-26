//
//  SwipeableView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI

struct SwipeableView<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    private let deleteButtonWidth: CGFloat = 80
    
    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Кнопка удаления (фон)
            deleteButton
            
            // Основной контент
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Свайп только влево
                            if gesture.translation.width < 0 {
                                offset = gesture.translation.width
                            }
                        }
                        .onEnded { gesture in
                            withAnimation(.spring(response: 0.3)) {
                                if gesture.translation.width < -deleteButtonWidth * 1.5 {
                                    // Полный свайп → сразу удалить
                                    offset = -500 // Анимация ухода
                                    HapticManager.medium()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onDelete()
                                    }
                                } else if gesture.translation.width < -50 {
                                    // Показать кнопку удаления
                                    offset = -deleteButtonWidth
                                    isSwiped = true
                                    HapticManager.light()
                                } else {
                                    // Вернуть обратно
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            withAnimation {
                HapticManager.medium()
                onDelete()
            }
        }) {
            ZStack {
                Color.theme.danger
                
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .font(.title3)
            }
        }
        .frame(width: deleteButtonWidth)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Design.cornerRadius))
    }
}

#Preview {
    SwipeableView(
        content: {
            HStack {
                Text("Свайпни влево")
                    .padding()
                Spacer()
            }
            .background(Color.white)
        },
        onDelete: {
            print("Удалено!")
        }
    )
    .padding()
}
