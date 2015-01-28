library(ggplot2);

csv <- "demographics.csv";
cjpeg <- "demplot/commits.jpeg";
gcjpeg <- "demplot/gcommits.jpeg";
cfjpeg <- "demplot/commits_vs_files.jpeg";
gcfjpeg <- "demplot/gcommits_vs_files.jpeg";
lfjpeg <- "demplot/lines_vs_files.jpeg";
glfjpeg <- "demplot/glines_vs_files.jpeg";
lcjpeg <- "demplot/lines_vs_commits.jpeg";
glcjpeg <- "demplot/glines_vs_commits.jpeg";
fjpeg <- "demplot/files.jpeg";
gfjpeg <- "demplot/gfiles.jpeg";
ljpeg <- "demplot/lines.jpeg";
gljpeg <- "demplot/glines.jpeg";
lhjpeg <- "demplot/lines_hist.jpeg";
fhjpeg <- "demplot/files_hist.jpeg";
chjpeg <- "demplot/commits_hist.jpeg";
tchjpeg <- "demplot/commits_hist_total.jpeg";

data <- read.csv(csv, col.name = c('commits', 'nfilesmod', 'lines_mod',
'lines_add', 'lines_rem', 'is_new_guard', 'com_guard_ratio', 'fil_guard_ratio',
'lnm_guard_ratio', 'lna_guard_ratio', 'lnr_guard_ratio', 'com_tot_ratio',
'fil_tot_ratio', 'lnm_tot_ratio', 'lna_tot_ratio', 'lnr_tot_ratio',
'full_name'));

cdata <- data[order(data[,1]),];
fdata <- data[order(data[,2]),];
ldata <- data[order(data[,3]),];

cdata$rownum <- seq(from = 1, to = nrow(cdata));
fdata$rownum <- seq(from = 1, to = nrow(fdata));
ldata$rownum <- seq(from = 1, to = nrow(ldata));

jpeg(cjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = rownum, y = com_tot_ratio)) + geom_point();

print(plotvar);
dev.off();

jpeg(gcjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = rownum, y = com_tot_ratio, colour =
is_new_guard)) + geom_point();

print(plotvar);
dev.off();

jpeg(cfjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = commits, y = nfilesmod)) + geom_point() +
geom_smooth(method=lm);

print(plotvar);
dev.off();

jpeg(gcfjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = commits, y = nfilesmod, colour =
is_new_guard)) + geom_point() + geom_smooth(method=lm);

print(plotvar);
dev.off();

jpeg(lfjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = lines_mod, y = nfilesmod)) + geom_point() +
geom_smooth(method=lm);

print(plotvar);
dev.off();

jpeg(glfjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = lines_mod, y = nfilesmod, colour =
is_new_guard)) + geom_point() + geom_smooth(method=lm);

print(plotvar);
dev.off();

jpeg(fjpeg, 720, 720);

plotvar <- ggplot(fdata, aes(x = rownum, y = fil_tot_ratio)) + geom_point();

print(plotvar);
dev.off();

jpeg(gfjpeg, 720, 720);

plotvar <- ggplot(fdata, aes(x = rownum, y = fil_tot_ratio, colour =
is_new_guard)) + geom_point();

print(plotvar);
dev.off();

jpeg(ljpeg, 720, 720);

plotvar <- ggplot(ldata, aes(x = rownum, y = lnm_tot_ratio, colour =
is_new_guard)) + geom_point();

print(plotvar);
dev.off();

jpeg(fhjpeg, 720, 720);

plotvar <- ggplot(fdata, aes(x = fil_tot_ratio)) +
geom_histogram(binwidth=0.001, fill="white", colour="black") +
facet_grid(is_new_guard ~ .);

print(plotvar);
dev.off();

jpeg(lhjpeg, 720, 720);

plotvar <- ggplot(ldata, aes(x = lnm_tot_ratio)) +
geom_histogram(binwidth=0.001, fill="white", colour="black") +
facet_grid(is_new_guard ~ .);

print(plotvar);
dev.off();

jpeg(chjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = com_tot_ratio)) +
geom_histogram(binwidth=0.001, fill="white", colour="black") +
facet_grid(is_new_guard ~ .);

print(plotvar);
dev.off();

jpeg(tchjpeg, 720, 720);

plotvar <- ggplot(cdata, aes(x = com_tot_ratio)) +
geom_histogram(binwidth=0.001, fill="white", colour="black")

print(plotvar);
dev.off();
