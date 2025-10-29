export const metadata = {
  title: '__PROJECT_NAME__',
  description: 'Next.js application transformed',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}

